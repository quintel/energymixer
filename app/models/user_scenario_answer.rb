class UserScenarioAnswer < ActiveRecord::Base
  belongs_to :user_scenario
  belongs_to :question
  belongs_to :answer
  
  validates :question_id, :presence => true
  
  attr_accessible :question_id, :answer_id
end
