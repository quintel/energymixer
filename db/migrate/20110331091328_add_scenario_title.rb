class AddScenarioTitle < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :title, :string
  end

  def self.down
    remove_column :scenarios, :title
  end
end
