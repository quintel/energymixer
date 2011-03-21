class RenameUserScenarios < ActiveRecord::Migration
  def self.up
    rename_table :user_scenarios, :scenarios
    rename_column :user_scenario_answers, :user_scenario_id, :scenario_id
    rename_table :user_scenario_answers, :scenario_answers
  end

  def self.down
    rename_table :scenarios, :user_scenarios
    rename_table :scenario_answers, :user_scenario_answers
    rename_column :user_scenario_answers, :scenario_id, :user_scenario_id
  end
end
