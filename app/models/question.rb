# == Schema Information
#
# Table name: questions
#
#  id              :integer(4)      not null, primary key
#  text_nl         :string(255)
#  ordering        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  description_nl  :text
#  question_set_id :integer(4)
#  text_de         :string(255)
#  description_de  :text
#

class Question < ActiveRecord::Base
  belongs_to :question_set
  has_many :answers, :dependent => :destroy
  
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc {|attrs| attrs['text_nl'].blank? }

  validates :text_nl, :presence => true

  scope :ordered, order('ordering, id')
  scope :excluding, lambda {|ids| where('id NOT IN (?)', ids) }
  
  attr_accessible :question_set_id, :ordering, :answers_attributes, :text_nl, :text_de, :description_nl, :description_de
  
  def number
    ordering + 1 rescue nil
  end
  
  def text
    send "text_#{I18n.locale}"
  end
  
  def description
    send "description_#{I18n.locale}"
  end
end
