class SaveUserAnswers < ActiveRecord::Migration
  def self.up
    add_column :user_scenarios, :answer_0, :integer
    add_column :user_scenarios, :answer_1, :integer
    add_column :user_scenarios, :answer_2, :integer
    add_column :user_scenarios, :answer_3, :integer
    add_column :user_scenarios, :answer_4, :integer
    add_column :user_scenarios, :answer_5, :integer
    add_column :user_scenarios, :answer_6, :integer
    add_column :user_scenarios, :answer_7, :integer
    add_column :user_scenarios, :answer_8, :integer
    add_column :user_scenarios, :answer_9, :integer
  end

  def self.down
    remove_column :user_scenarios, :answer_0
    remove_column :user_scenarios, :answer_1
    remove_column :user_scenarios, :answer_2
    remove_column :user_scenarios, :answer_3
    remove_column :user_scenarios, :answer_4
    remove_column :user_scenarios, :answer_5
    remove_column :user_scenarios, :answer_6
    remove_column :user_scenarios, :answer_7
    remove_column :user_scenarios, :answer_8
    remove_column :user_scenarios, :answer_9
  end
end
