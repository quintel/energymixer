# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  answer      :string(255)
#  ordering    :integer(4)
#  question_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  description :text
#

class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs, :dependent => :destroy do
    def slider_values
      all.inject({}) do |sliders, input|
        sliders[input.slider_id] = input.value
        sliders
      end
    end
  end
  
  accepts_nested_attributes_for :inputs, 
    :allow_destroy => true,
    :reject_if => proc {|attrs| attrs['key'].blank? && attrs['value'].blank? }
  
  validates :answer, :presence => true
  
  scope :ordered, order('ordering, id')
  
  def letter
    ('A'..'Z').to_a[ordering] rescue nil
  end
end

