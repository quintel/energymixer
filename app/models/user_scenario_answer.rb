# == Schema Information
#
# Table name: user_scenario_answers
#
#  id               :integer(4)      not null, primary key
#  user_scenario_id :integer(4)
#  question_id      :integer(4)
#  answer_id        :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class UserScenarioAnswer < ActiveRecord::Base
  belongs_to :user_scenario
  belongs_to :question
  belongs_to :answer
  
  validates :question_id, :presence => true
  
  attr_accessible :question_id, :answer_id
end
