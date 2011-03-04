class Input < ActiveRecord::Base
  belongs_to :answer

  validates :key, :presence => true
end
