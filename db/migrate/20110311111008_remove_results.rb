class RemoveResults < ActiveRecord::Migration
  def self.up
    remove_table :results
  end

  def self.down
    create_table "results", :force => true do |t|
      t.string   "gquery"
      t.string   "key"
      t.string   "description"
      t.string   "group"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
