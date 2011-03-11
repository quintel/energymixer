# == Schema Information
#
# Table name: results
#
#  id          :integer(4)      not null, primary key
#  gquery      :string(255)
#  key         :string(255)
#  description :string(255)
#  group       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Result < ActiveRecord::Base
  
  def as_json(options={})
    gquery
  end
end
