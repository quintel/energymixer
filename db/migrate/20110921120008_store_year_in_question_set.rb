class StoreYearInQuestionSet < ActiveRecord::Migration
  def self.up
    add_column :question_sets, :end_year, :integer
  end

  def self.down
    remove_column :question_sets, :end_year
  end
end
