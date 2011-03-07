class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs, :dependent => :destroy
  
  accepts_nested_attributes_for :inputs, :allow_destroy => true, :reject_if => proc {|attrs| attrs['key'].blank? }
  
  validates :answer, :presence => true
  
  scope :ordered, order('ordering, id')
  
  def letter
    ('A'..'Z').to_a[ordering]
  end
  
end
