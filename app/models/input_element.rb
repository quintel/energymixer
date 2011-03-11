class InputElement < ActiveRecord::Base

  validates :key, :presence => true, :uniqueness => true, :length => { :maximum => 255 }

end
