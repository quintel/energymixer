class ScenarioPublicFlag < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :public, :boolean, :default => true
    add_index :scenarios, :public
  end

  def self.down
    remove_column :scenarios, :public
  end
end
