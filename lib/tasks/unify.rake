desc <<-DESC
  Merge two databases

  A script for merging two EnergyMixer databases. This will take a "canonical"
  database and a directory to a XML export of a second database, and merge the
  exported XML data into the canonical DB.

  The export should be created with the Sequel OS X application, by selecting
  all the tables, and choosing the XML tab. Customise the filename to include
  just "table", click "New file per table", and "Format: Plain Schema". The
  path should be set to ENERGYMIXER_DIR/unify.

  All IDs from the exported database will be changed from their originals
  (otherwise they would likely conflict with those in the new DB) but
  references (e.g. between questions and question sets) will be tracked and
  maintained after the merge. Duplicate users and popups will be discarded,
  as will scenario answers whose parent scenario no longer exists.
DESC

task unify: :environment do

  # REQUIRES -----------------------------------------------------------------

  require 'ostruct'

  # CLASSES ------------------------------------------------------------------

  # Maintains a collection of IDs from the old database, and their new IDs.
  class TableReference
    def initialize(name)
      @name = name
      @map  = Hash.new
    end

    def set(old_id, new_id)
      @map[old_id.to_i] = new_id.to_i
    end

    def get(old_id)
      @map.fetch(old_id.to_i)
    end
  end

  # Represents a row from a table being imported.
  class Row < Hash
    def update_foreign_key!(key, reference)
      self[key] = reference.get(self[key])
    end
  end

  # Parses an XML file and yields each parsed row.
  def xml(name)
    puts ">> Beginning #{name}"

    parsed = ActiveSupport::XmlMini.parse(File.read("unify/#{name}.xml"))

    Array.wrap(parsed['mixer'][name]['row']).each do |line|
      yield handle_line(line)
    end
  end

  # Takes a line from the XML and returns a nicely formatted hash with the
  # data.
  def handle_line(attributes)
    attributes.each_with_object(Row.new) do |(key, value), data|
      value = value['__content__']

      data[key.to_sym] =
        case value
          when /^\d+$/                            then value.to_i
          when /^\d+\.\d+$/                       then value.to_f
          when /^\d{4}-\d\d-\d\d$/                then Date.parse(value)
          when /^\d{4}-\d\d-\d\d \d\d:\d\d:\d\d$/ then Time.parse(value)
          when 'NULL', nil                        then nil
          else                                         value.strip
        end
    end
  end

  # Creates a new record of the given class, with the given attributes.
  def create_record(klass, attributes)
    record = klass.new

    attributes.each do |key, value|
      record.public_send(:"#{key}=", value) unless key == :id
    end

    record.save!
    record
  end

  # Inserts a new record using data from the given line, inserting the new
  # primary key into the TableReference.
  def insert(line, model, reference)
    reference.set(line[:id], create_record(model, line).id)
    say "Inserted #{ model.name } #{ line[:name] || line[:id] }"
  end

  # Say something, formatted for "unify" output.
  def say(message)
    puts "   #{ message }"
  end

  # CONSTANTS ----------------------------------------------------------------

  # Holds all the TableReference instances for each model.
  REFS = OpenStruct.new(
    answers:          TableReference.new(:answer),
    answer_conflicts: TableReference.new(:answer_conflict),
    dashboard_items:  TableReference.new(:dashboard_item),
    inputs:           TableReference.new(:input),
    popups:           TableReference.new(:popup),
    questions:        TableReference.new(:question),
    question_sets:    TableReference.new(:question_set),
    scenarios:        TableReference.new(:scenario),
    scenario_answers: TableReference.new(:scenario_answer)
  )

  # SCRIPT -------------------------------------------------------------------

  # Preserve the original timestamps.
  ActiveRecord::Base.record_timestamps = false

  ActiveRecord::Base.transaction do

    # Question sets.

    xml('question_sets') do |line|
      insert line, QuestionSet, REFS.question_sets
    end

    # Questions.

    xml('questions') do |line|
      line.update_foreign_key!(:question_set_id, REFS.question_sets)
      insert(line, Question, REFS.questions)
    end

    # Answers.

    xml('answers') do |line|
      line.update_foreign_key!(:question_id, REFS.questions)
      insert(line, Answer, REFS.answers)
    end

    # Answer conflicts.

    xml('answer_conflicts') do |line|
      line.update_foreign_key!(:answer_id,       REFS.answers)
      line.update_foreign_key!(:other_answer_id, REFS.answers)

      insert(line, AnswerConflict, REFS.answer_conflicts)
    end

    # Inputs.

    xml('inputs') do |line|
      line.update_foreign_key!(:answer_id, REFS.answers)
      insert(line, Input, REFS.inputs)
    end

    # Scenarios.

    xml('scenarios') do |line|
      insert(line, Scenario, REFS.scenarios)
    end

    # Scenario answers.

    xml('scenario_answers') do |line|
      line.update_foreign_key!(:question_id, REFS.questions)

      # Silently ignore missing answers.
      line.update_foreign_key!(:answer_id, REFS.answers) rescue nil

      begin
        line.update_foreign_key!(:scenario_id, REFS.scenarios)
        insert(line, ScenarioAnswer, REFS.scenario_answers)
      rescue KeyError => e
        say "Skipped ScenarioAnswer (missing scenario): #{ e.message }"
      end
    end

    # Popups.

    xml('popups') do |line|
      if Popup.where(code: line[:code]).length.zero?
        create_record(Popup, line)
        say "Inserted Popup #{ line[:code] }"
      else
        say "Skipping duplicate popup: #{line[:code]}"
      end
    end

    # Dashboard items.

    xml('dashboard_items') do |line|
      line[:question_set_id] = QuestionSet.last.id
      create_record(DashboardItem, line)
      say "Inserted DashboardItem: #{line[:gquery]}"
    end

    puts '>> All done!'

  end # Transaction

end
