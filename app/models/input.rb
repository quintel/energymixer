# == Schema Information
#
# Table name: inputs
#
#  id         :integer(4)      not null, primary key
#  value      :decimal(10, 2)
#  answer_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  key        :string
#

class Input < ActiveRecord::Base
  belongs_to :answer

  validates :key, :presence => true
  validates :value, :presence => true

  attr_accessible :value, :key

  def self.available_inputs
    Rails.cache.fetch('available_inputs') do
      hash = {}
      Api::Input.all(:from => :list).sort_by(&:key).each{|i| hash[i.id] = i.key}
      hash
    end
  end
end
