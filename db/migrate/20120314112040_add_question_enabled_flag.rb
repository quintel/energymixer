class AddQuestionEnabledFlag < ActiveRecord::Migration
  def self.up
    add_column :questions, :enabled, :boolean, :default => true
    add_index :questions, :enabled
  end

  def self.down
    remove_column :questions, :enabled
  end
end
