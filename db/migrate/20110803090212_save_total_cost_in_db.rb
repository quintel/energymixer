class SaveTotalCostInDb < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :output_12, :float
  end

  def self.down
    remove_column :scenarios, :output_12
  end
end
