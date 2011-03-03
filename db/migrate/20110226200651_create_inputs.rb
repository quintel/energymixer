class CreateInputs < ActiveRecord::Migration
  def self.up
    create_table :inputs do |t|
      t.string :key
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :answer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inputs
  end
end
