class AddAnswerDescription < ActiveRecord::Migration
  def self.up
    add_column :answers, :description, :text 
  end

  def self.down
    remove_column :answers, :description
  end
end
