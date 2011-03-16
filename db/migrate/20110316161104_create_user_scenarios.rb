class CreateUserScenarios < ActiveRecord::Migration
  def self.up
    create_table :user_scenarios do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.boolean :featured
      t.float :output_0
      t.float :output_1
      t.float :output_2
      t.float :output_3
      t.float :output_4
      t.float :output_5
      t.float :output_6
      t.float :output_7
      t.float :output_8
      t.timestamps
    end
    
    add_index :user_scenarios, :featured
  end

  def self.down
    drop_table :user_scenarios
  end
end
