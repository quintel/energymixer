class AddInformationToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :information, :text
  end

  def self.down
    remove_column :questions, :information
  end
end