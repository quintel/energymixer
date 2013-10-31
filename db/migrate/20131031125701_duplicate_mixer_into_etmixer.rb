class DuplicateMixerIntoEtmixer < ActiveRecord::Migration
  def up
    answer_map  = {}

    original    = QuestionSet.where(name: 'mixer').first
    replacement = QuestionSet.where(name: 'etmixer').first

    have_saved(original, replacement)

    # Questions

    original.questions.each do |question|
      new_question = Question.new(attrs(question))
      new_question.question_set = replacement
      new_question.ordering = new_question.ordering + 100
      new_question.enabled  = false
      new_question.save!

      have_saved(question, new_question)

      # Answers

      question.answers.each do |answer|
        new_answer = Answer.new(attrs(answer, :question_id))
        new_answer.question = new_question
        new_answer.save!

        have_saved(answer, new_answer)

        answer_map[answer.id] = new_answer.id

        # Inputs

        answer.inputs.each do |input|
          new_input = Input.new(attrs(input))
          new_input.answer_id = new_answer.id
          new_input.save!

          have_saved(input, new_input)
        end
      end
    end

    # Dashboard items

    original.dashboard_items.each do |dash|
      new_item = DashboardItem.new(attrs(dash))
      new_item.question_set_id = replacement.id
      new_item.save!

      have_saved(dash, new_item)
    end

    # Answer conflicts

    conflicts = original.questions.
      map(&:answers).flatten.
      map(&:answer_conflicts).flatten

    conflicts.each do |conflict|
      new_conflict = AnswerConflict.new
      new_conflict.answer_id = answer_map[conflict.answer_id]
      new_conflict.other_answer_id = answer_map[conflict.other_answer_id]

      new_conflict.save!

      puts "Saved AnswerConflict #{ new_conflict.id } [#{conflict.answer_id.inspect}, #{conflict.other_answer_id.inspect}] => " \
        "[#{ answer_map[conflict.answer_id].inspect }, #{ answer_map[conflict.other_answer_id].inspect }]"
    end
  end

  def down
    replacement = QuestionSet.where(name: 'etmixer').first
    replacement.questions.where('ordering >= ?', 100).each(&:destroy!)
  end

  def attrs(original, also = [])
    original.attributes.except(:id, :created_at, :updated_at, *also)
  end

  def have_saved(old_thing, new_thing)
    puts "Saved #{ old_thing.class.name } #{ old_thing.id } => #{ new_thing.id }"
  end
end
