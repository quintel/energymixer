class RemoveKeyFromInputs < ActiveRecord::Migration
  def self.up
    remove_column :inputs, :key
  end

  def self.down
    add_column :inputs, :key, :string
  end
end
