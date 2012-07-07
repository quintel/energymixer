class AddQuestionSetIdToScenarios < ActiveRecord::Migration
  def up
    add_column :scenarios, :question_set_id, :integer, null: false

    Scenario.reset_column_information

    question_set = QuestionSet.first

    Scenario.all.each do |item|
      item.question_set_id = question_set.id
      item.save!(:validate => false)
    end
  end

  def down
    remove_column :scenarios, :question_set_id
  end
end
