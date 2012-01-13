# == Schema Information
#
# Table name: dashboard_items
#
#  id         :integer(4)      not null, primary key
#  gquery     :string(255)
#  label      :string(255)
#  steps      :string(255)
#  ordering   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class DashboardItem < ActiveRecord::Base
  validates :gquery, :presence => true
  validates :label, :presence => true

  scope :ordered, order('ordering, id')

  attr_accessible :gquery, :label, :steps, :ordering

  # If we're defining some steps in the object field we can use this
  # method to check the step a value belongs to
  def corresponding_step(value)
    steps_array = steps.split(",").map(&:to_f) rescue []
    step = 0
    steps_array.each_with_index do |v, i|
      step = i + 1 if value > v
    end
    step
  end
end
