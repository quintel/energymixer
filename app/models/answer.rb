# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  answer      :text
#  ordering    :integer(4)
#  question_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  description :text
#

class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs,                   :dependent => :destroy
  has_many :scenario_answers,         :dependent => :destroy
  has_many :answer_conflicts,         :dependent => :destroy
  has_many :inverse_answer_conflicts, :dependent => :destroy, :class_name => 'AnswerConflict', :foreign_key => 'other_answer_id'
  
  accepts_nested_attributes_for :inputs, :allow_destroy => true, :reject_if => proc {|attr| attr['key'].blank? && attr['value'].blank? }
  
  validates :text_nl, :presence => true
  
  scope :ordered, order('ordering, id')
  
  attr_accessible :inputs_attributes, :ordering, :text_nl, :text_de, :description_nl, :description_de, :conflicting_answer_ids, :answer_conflicts
  
  def conflicting_answers
    Answer.find(conflicting_answer_ids)
  end
  
  def conflicting_answer_ids
    answer_conflicts.map(&:other_answer_id) + inverse_answer_conflicts.map(&:answer_id)
  end
    
  def conflicting_answer_ids=(ids)
    answer_conflicts.destroy_all
    inverse_answer_conflicts.destroy_all
    ids.each{|i| answer_conflicts.build(:other_answer_id => i)}
  end
    
  def conflicts_with?(ans)
    conflicting_answer_ids.include?(ans.id)
  end
  
  def text
    send "text_#{I18n.locale}"
  end
  
  def description
    send "description_#{I18n.locale}"
  end
    
end
