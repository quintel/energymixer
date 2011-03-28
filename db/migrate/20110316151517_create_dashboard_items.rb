class CreateDashboardItems < ActiveRecord::Migration
  def self.up
    create_table :dashboard_items do |t|
      t.string :gquery
      t.string :label
      t.string :steps
      t.integer :ordering

      t.timestamps
    end
    
    add_index :dashboard_items, :ordering
  end

  def self.down
    drop_table :dashboard_items
  end
end
