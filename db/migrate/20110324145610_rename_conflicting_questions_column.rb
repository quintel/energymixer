class RenameConflictingQuestionsColumn < ActiveRecord::Migration
  def self.up
    rename_column :answers, :conflicting_questions, :conflicting_answer_ids_string
  end

  def self.down
    rename_column :answers, :conflicting_answer_ids_string, :conflicting_questions
  end
end
