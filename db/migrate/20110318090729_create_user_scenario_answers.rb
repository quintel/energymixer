class CreateUserScenarioAnswers < ActiveRecord::Migration
  def self.up
    create_table :user_scenario_answers do |t|
      t.integer :user_scenario_id
      t.integer :question_id
      t.integer :answer_id

      t.timestamps
    end
    
    add_index :user_scenario_answers, :user_scenario_id
    add_index :user_scenario_answers, :question_id
  end

  def self.down
    drop_table :user_scenario_answers
  end
end
