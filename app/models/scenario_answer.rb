# == Schema Information
#
# Table name: scenario_answers
#
#  id          :integer(4)      not null, primary key
#  scenario_id :integer(4)
#  question_id :integer(4)
#  answer_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  score       :float
#

class ScenarioAnswer < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :question
  belongs_to :answer

  validates :question_id, :presence => true

  attr_accessible :question_id, :answer_id, :score
end
