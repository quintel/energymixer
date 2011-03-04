class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs
  
  accepts_nested_attributes_for :inputs,
    :allow_destroy => true, :reject_if => proc {|attrs| attrs['key'].blank? }
end
