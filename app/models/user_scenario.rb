# == Schema Information
#
# Table name: user_scenarios
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  age        :integer(4)
#  featured   :boolean(1)
#  output_0   :float
#  output_1   :float
#  output_2   :float
#  output_3   :float
#  output_4   :float
#  output_5   :float
#  output_6   :float
#  output_7   :float
#  output_8   :float
#  created_at :datetime
#  updated_at :datetime
#

class UserScenario < ActiveRecord::Base
  validates :name,  :presence => true
  validates :email, :presence => true
  validates :output_0, :presence => true
  validates :output_1, :presence => true
  validates :output_2, :presence => true
  validates :output_3, :presence => true
  validates :output_4, :presence => true
  validates :output_5, :presence => true
  validates :output_6, :presence => true
  validates :output_7, :presence => true
  validates :output_8, :presence => true
  
  scope :recent_first, order('created_at DESC')
end
