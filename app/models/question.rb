# == Schema Information
#
# Table name: questions
#
#  id          :integer(4)      not null, primary key
#  question    :string(255)
#  ordering    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  information :text
#

class Question < ActiveRecord::Base
  has_many :answers, :dependent => :destroy
  
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc {|attrs| attrs['answer'].blank? }

  validates :question, :presence => true

  scope :ordered, order('ordering, id')
  scope :excluding, lambda {|ids| where('id NOT IN (?)', ids) }
  
  attr_accessible :question, :ordering, :information, :answers_attributes
  
  def number
    ordering + 1 rescue nil
  end
end

