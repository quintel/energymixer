class AddSliderIdToInputs < ActiveRecord::Migration
  def self.up
    add_column :inputs, :slider_id, :integer
  end

  def self.down
    remove_column :inputs, :slider_id
  end
end
