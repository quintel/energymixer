class Result < ActiveRecord::Base
  
  def as_json(options={})
    gquery
  end
end