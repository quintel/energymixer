class DeleteInputElements < ActiveRecord::Migration
  def self.up
    drop_table :input_elements
  end

  def self.down
    create_table :input_elements do |t|
      t.string :key
    end
    add_index :input_elements, :key, :unique => true
  end
end
