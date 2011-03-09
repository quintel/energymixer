class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results, :force => true do |t|
      t.string :gquery
      t.string :key
      t.string :description
      t.string :group
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end