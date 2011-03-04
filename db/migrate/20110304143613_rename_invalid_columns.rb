class RenameInvalidColumns < ActiveRecord::Migration
  def self.up
    rename_column :questions, :order, :ordering
    rename_column :answers, :order, :ordering
    
    add_index :questions, :ordering
    add_index :answers, :ordering
  end

  def self.down
    rename_column :questions, :ordering, :order
    rename_column :answers, :ordering, :order
  end
end
