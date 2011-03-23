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
  
  attr_accessible :inputs_attributes, :ordering, :answer, :description, :conflicting_question_ids
  
  def conflicting_question_ids
    conflicting_questions.split(",").map(&:to_i) rescue nil
  end
  
  def conflicting_question_ids=(ids)
    self.conflicting_questions = ids.join(",")
  end
end

