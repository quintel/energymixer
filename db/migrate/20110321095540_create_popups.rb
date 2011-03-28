class CreatePopups < ActiveRecord::Migration
  def self.up
    create_table :popups do |t|
      t.string :code
      t.string :title
      t.text :body

      t.timestamps
    end
    
    add_index :popups, :code
  end

  def self.down
    drop_table :popups
  end
end
