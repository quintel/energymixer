class StoreEtmScenarioId < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :etm_scenario_id, :integer
  end

  def self.down
    remove_column :scenarios, :etm_scenario_id
  end
end
