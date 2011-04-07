class AddExtraOutputs < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :output_9,  :float
    add_column :scenarios, :output_10, :float
    add_column :scenarios, :output_11, :float
  end

  def self.down
    remove_column :scenarios, :output_9
    remove_column :scenarios, :output_10
    remove_column :scenarios, :output_11
  end
end
