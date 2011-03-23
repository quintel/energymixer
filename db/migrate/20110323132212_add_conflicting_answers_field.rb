class AddConflictingAnswersField < ActiveRecord::Migration
  def self.up
    add_column :answers, :conflicting_questions, :string
  end

  def self.down
    remove_column :answers, :conflicting_questions
  end
end
