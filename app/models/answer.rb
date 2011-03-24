# == Schema Information
#
# Table name: answers
#
#  id                    :integer(4)      not null, primary key
#  answer                :string(255)
#  ordering              :integer(4)
#  question_id           :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  description           :text
#  conflicting_questions :string(255)
#

class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs, :dependent => :destroy 
  
  accepts_nested_attributes_for :inputs, :allow_destroy => true, :reject_if => proc {|attr| attr['key'].blank? && attr['value'].blank? }
  
  validates :answer, :presence => true
  
  scope :ordered, order('ordering, id')
  
  attr_accessible :inputs_attributes, :ordering, :answer, :description, :conflicting_answer_ids
  
  # We are storing the conflicting answers as a comma separated list
  # Let's keep things simple
  def conflicting_answers
    Answer.find(conflicting_answer_ids)
  end
  
  def conflicting_answer_ids
    conflicting_answer_ids_string.split(",").map(&:to_i) rescue []
  end
  
  def conflicting_answer_ids=(ids)
    self.conflicting_answer_ids_string = ids.join(",")
  end
end

