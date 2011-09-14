# == Schema Information
#
# Table name: inputs
#
#  id         :integer(4)      not null, primary key
#  value      :decimal(10, 2)
#  answer_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  slider_id  :integer(4)
#

class Input < ActiveRecord::Base
  belongs_to :answer
  
  validates :slider_id, :presence => true
  
  attr_accessible :value, :slider_id, :key, :slider_name
  
  def slider_name
    self.class.available_inputs[slider_id] rescue nil
  end
  alias_method :slider, :slider_name
  
  def slider_name=(s)
    self.slider_id = self.class.available_inputs.invert[s]
  end
  
  def self.available_inputs
    Rails.cache.fetch('available_inputs') do
      hash = {}
      Api::Input.all.sort_by(&:key).each{|i| hash[i.id] = i.key}
      hash
      # DEBT: one-liner
      # Api::Input.all.sort_by(:key).inject({}) {|hsh,i| hsh.merge i.id => i.key}
      # +each+ makes the code easier to read and is *way* faster
      #       user     system      total        real
      # each:  1.040000   0.000000   1.040000 (  1.035372)
      # inject: 18.190000   0.080000  18.270000 ( 18.232147)
      # - PZ
    end
  end
end
