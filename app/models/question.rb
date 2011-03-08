class Question < ActiveRecord::Base
  has_many :answers, :dependent => :destroy
  
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc {|attrs| attrs['answer'].blank? }

  validates :question, :presence => true
  
  scope :ordered, order('ordering, id')
  
  def number
    ordering+1
  end
end
