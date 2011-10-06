class StoreScenarioYear < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :year, :integer
  end

  def self.down
    remove_column :scenarios, :year
  end
end
