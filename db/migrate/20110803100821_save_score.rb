class SaveScore < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :score, :float
    add_index :scenarios, :score
    add_column :scenario_answers, :score, :float
  end

  def self.down
    remove_column :scenarios, :score
    remove_column :scenario_answers, :score
  end
end
