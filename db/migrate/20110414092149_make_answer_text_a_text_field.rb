class MakeAnswerTextATextField < ActiveRecord::Migration
  def self.up
    change_column :answers, :answer, :text
  end

  def self.down
    change_column :answers, :answer, :string
  end
end
