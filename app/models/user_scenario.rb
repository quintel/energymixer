# == Schema Information
#
# Table name: user_scenarios
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  age        :integer(4)
#  featured   :boolean(1)
#  output_0   :float
#  output_1   :float
#  output_2   :float
#  output_3   :float
#  output_4   :float
#  output_5   :float
#  output_6   :float
#  output_7   :float
#  output_8   :float
#  created_at :datetime
#  updated_at :datetime
#

class UserScenario < ActiveRecord::Base  
  has_many :answers, :class_name => 'UserScenarioAnswer', :dependent => :destroy

  accepts_nested_attributes_for :answers
  
  # Be careful, these values must match the dashboard items
  # We could store this mapping in the db, but let's keep things simple
  Outputs = {
    output_0: "costs_share_of_coal",
    output_1: "costs_share_of_gas",
    output_2: "costs_share_of_oil",
    output_3: "costs_share_of_uranium",
    output_4: "costs_share_of_sustainable",
    output_5: "co2_emission_final_demand_to_1990_in_percent",
    output_6: "share_of_renewable_energy",
    output_7: "area_footprint_per_nl",
    output_8: "energy_dependence"
  }
  
  validates :name,  :presence => true
  validates :email, :presence => true
  validates :output_0, :presence => true
  validates :output_1, :presence => true
  validates :output_2, :presence => true
  validates :output_3, :presence => true
  validates :output_4, :presence => true
  validates :output_5, :presence => true
  validates :output_6, :presence => true
  validates :output_7, :presence => true
  validates :output_8, :presence => true
  
  scope :recent_first, order('created_at DESC')
  scope :featured, where(:featured => true)
  scope :featured_first, order('featured DESC')
  # shall we use SOLR/TS/?
  scope :by_user, lambda {|q| where('name LIKE ?', "%#{q}%")}
  
  paginates_per 20
    
  def carriers
    {
      coal:      { label: "Coal",      amount: output_0, ratio: output_0 / total_amount },
      gas:       { label: "Gas",       amount: output_1, ratio: output_1 / total_amount },
      oil:       { label: "Oil",       amount: output_2, ratio: output_2 / total_amount },
      nuclear:   { label: "Nuclear",   amount: output_3, ratio: output_3 / total_amount },
      renewable: { label: "Renewable", amount: output_4, ratio: output_4 / total_amount }
    }
  end
  
  def max_amount
    80_000_000_000
  end
  
  # Ugly
  def total_amount
    output_0 + output_1 + output_2 + output_3 + output_4
  end
end
