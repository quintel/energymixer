# == Schema Information
#
# Table name: popups
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Popup < ActiveRecord::Base
  validates :code, :presence => true, :uniqueness => true
  validates :title, :presence => true
  validates :body, :presence => true
  
  attr_accessible :code, :title, :body
end
