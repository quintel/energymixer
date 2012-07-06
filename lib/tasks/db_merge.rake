desc <<-DESC
  Merge two databases

  A script for merging two EnergyMixer databases. This will take a "canonical"
  database and a directory to a CSV export of a second database, and merge the
  exported CSV data into the canonical DB.

  All IDs from the exported database will be changed from their originals
  (otherwise they would likely conflict with those in the new DB) but
  references (e.g. between questions and question sets) will be tracked and
  maintained after the merge.
DESC

task unify: :environment do

  # REQUIRES -----------------------------------------------------------------

  require 'ostruct'

  # CLASSES ------------------------------------------------------------------

  # Maintains a collection of IDs from the old database, and their new IDs.
  class TableReference
    def initialize(name)
      @name = name
      @fkey = name.to_s.foreign_key.to_sym
      @map  = Hash.new
    end

    def set(old_id, new_id)
      @map[old_id.to_i] = new_id.to_i
    end

    def get(old_id)
      @map.fetch(old_id.to_i)
    end

    def length
      @map.length
    end

    def update!(line, key = @fkey)
      old_id = get(line[key])
      line[key] = old_id
      line
    end

    def inspect
      "#<TableReference(#{@name}) #{@map.inspect}>"
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
    attributes.each_with_object(Hash.new) do |(key, value), data|
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

  # Say something, formatted for "unify" output.
  def say(message)
    puts "   #{ message }"
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

  ActiveRecord::Base.record_timestamps = false

  ActiveRecord::Base.transaction do

    # Question sets.

    xml('question_sets') do |line|
      REFS.question_sets.set(line[:id], create_record(QuestionSet, line).id)
      say "Inserted question set: #{line[:name]}"
    end

    # Questions.

    xml('questions') do |line|
      REFS.question_sets.update!(line)
      REFS.questions.set(line[:id], create_record(Question, line).id)
      say "Inserted question: #{line[:id]}"
    end

    # Answers.

    xml('answers') do |line|
      REFS.questions.update!(line)
      REFS.answers.set(line[:id], create_record(Answer, line).id)
      say "Inserted answer: #{line[:id]}"
    end

    # Answer conflicts.

    xml('answer_conflicts') do |line|
      REFS.answers.update!(line)
      REFS.answers.update!(line, :other_answer_id)

      REFS.answer_conflicts.set(
        line[:id], create_record(AnswerConflict, line).id)
        say "Inserted answer conflict: #{line[:id]}"
    end

    # Inputs.

    xml('inputs') do |line|
      REFS.answers.update!(line)
      REFS.inputs.set(line[:id], create_record(Input, line).id)
      say "Inserted input: #{line[:id]}"
    end

    # Scenarios.

    xml('scenarios') do |line|
      REFS.scenarios.set(line[:id], create_record(Scenario, line).id)
      say "Inserted scenario: #{line[:name]} (#{line[:id]})"
    end

    # Scenario answers.

    xml('scenario_answers') do |line|
      REFS.questions.update!(line)

      begin
        REFS.answers.update!(line)
      rescue KeyError
        # Silently ignore missing answers.
      end

      begin
        REFS.scenarios.update!(line)

        REFS.scenario_answers.set(
          line[:id], create_record(ScenarioAnswer, line).id)

        say "Inserted scenario answer: #{line[:id]}"
      rescue KeyError => e
        say "Skipped scenario answer due to missing scenario: #{ e.message }"
      end
    end

    # Popups.

    xml('popups') do |line|
      if Popup.where(code: line[:code]).length.zero?
        REFS.popups.set(line[:id], create_record(Popup, line).id)
        say "Inserted popup: #{line[:code]}"
      else
        say "Skipping duplicate popup: #{line[:code]}"
      end
    end

    # Dashboard items.

    xml('dashboard_items') do |line|
      line[:question_set_id] = QuestionSet.last.id

      REFS.dashboard_items.set(
        line[:id], create_record(DashboardItem, line).id)

      say "Inserted dashboard item: #{line[:label]}"
    end

    puts '>> All done!'

  end # Transaction

end
