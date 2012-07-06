class UnifyDashboard < ActiveRecord::Migration
  def up
    add_column :dashboard_items, :question_set_id, :integer, null: false

    DashboardItem.reset_column_information

    question_set = QuestionSet.first

    DashboardItem.all.each do |item|
      item.question_set_id = question_set.id
      item.save!
    end
  end

  def down
    remove_column :dashboard_items, :question_set_id
  end
end
