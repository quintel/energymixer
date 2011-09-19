class AddAverageScenarioFlag < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :average, :boolean, :default => false
    add_index :scenarios, :average
  end

  def self.down
    remove_column :scenarios, :average
  end
end
