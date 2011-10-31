# == Schema Information
#
# Table name: popups
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  title_nl   :string(255)
#  body_nl    :text
#  created_at :datetime
#  updated_at :datetime
#  title_de   :string(255)
#  body_de    :text
#  video_nl   :string(255)
#  video_de   :string(255)
#

class Popup < ActiveRecord::Base
  validates :code, :presence => true, :uniqueness => true
  validates :title_nl, :presence => true
  validates :body_nl, :presence => true
  
  attr_accessible :code, :title_nl, :body_nl, :title_de, :body_de
  
  def title
    send "title_#{I18n.locale}"
  end
  
  def body
    send "body_#{I18n.locale}"
  end
  
  def video
    send "video_#{I18n.locale}"
  end
end
