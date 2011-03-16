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
  validates :steps, :presence => true
  
  scope :ordered, order('ordering, id')
  
  # A word about steps: something like this [0.0, 0.25, 0.5, 0.75]
  # is translated in the following categories:
  # * [-inf, 0.0]   css_suffix: _0 # boundary check
  # * [0.0, 0.25]   css_suffix: _0
  # * (0.25), 0.5]   css_suffix: _1
  # * (0.5), 0.75]   css_suffix: _2
  # * (0.75), +inf]  css_suffix: _3
  # The CSS file should define classes named as the gquery + the suffix
    
end
