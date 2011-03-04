class CreateInputs < ActiveRecord::Migration
  def self.up
    create_table :inputs do |t|
      t.string :key
      t.decimal :value
      t.integer :answr_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inputs
  end
end
