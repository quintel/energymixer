class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :answer
      t.integer :order
      t.integer :question_id

      t.timestamps
    end
    
    add_index :answers, :question_id
  end

  def self.down
    drop_table :answers
  end
end
