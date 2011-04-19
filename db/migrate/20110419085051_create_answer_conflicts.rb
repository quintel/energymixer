class CreateAnswerConflicts < ActiveRecord::Migration
  def self.up
    create_table :answer_conflicts do |t|
      t.integer :answer_id
      t.integer :other_answer_id
    end
    
    add_index :answer_conflicts, :answer_id
    add_index :answer_conflicts, :other_answer_id
    
    AnswerConflict.reset_column_information
    
    Answer.find_each do |a|
      a_id = a.id
      next unless a.conflicting_answer_ids_string
      a.conflicting_answer_ids_string.split(",").each do |other_id|
        AnswerConflict.create(:answer_id => a_id, :other_answer_id => other_id)
      end
    end
    
    remove_column :answers, :conflicting_answer_ids_string
  end

  def self.down
    drop_table :answer_conflicts
    add_column :answers, :conflicting_answer_ids_string, :string
  end
end
