class CreateQuestionSets < ActiveRecord::Migration
  def self.up
    create_table :question_sets do |t|
      t.string :name
      t.boolean :enabled

      t.timestamps
    end
    
    QuestionSet.create(:name => 'main')
    
    add_column :questions, :question_set_id, :integer
    
    Question.reset_column_information
    Question.update_all(:question_set_id => 1)
  end

  def self.down
    drop_table :question_sets
    remove_column :questions, :question_set_id
  end
end
