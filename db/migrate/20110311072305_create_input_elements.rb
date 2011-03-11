class CreateInputElements < ActiveRecord::Migration
  def self.up
    create_table :input_elements do |t|
      t.string :key
    end

    add_index :input_elements, :key, :unique => true
  end

  def self.down
    drop_table :input_elements
  end
end
