# == Schema Information
#
# Table name: scenarios
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email           :string(255)
#  age             :integer(4)
#  featured        :boolean(1)      default(FALSE), not null
#  output_0        :float
#  output_1        :float
#  output_2        :float
#  output_3        :float
#  output_4        :float
#  output_5        :float
#  output_6        :float
#  output_7        :float
#  output_8        :float
#  created_at      :datetime
#  updated_at      :datetime
#  title           :string(255)
#  etm_scenario_id :integer(4)
#  output_9        :float
#  output_10       :float
#  output_11       :float
#  public          :boolean(1)      default(TRUE)
#  output_12       :float
#  score           :float
#  average         :boolean(1)      default(FALSE)
#

class Scenario < ActiveRecord::Base
  MaxAmount = APP_CONFIG["max_total_cost"] || 100_000_000_000
  
  has_many :answers, :class_name => 'ScenarioAnswer', :dependent => :destroy

  accepts_nested_attributes_for :answers
  
  # Be careful, these values must match the dashboard items
  # We could store this mapping in the db, but let's keep things simple
  Outputs = {
    output_0:  "share_of_total_costs_assigned_to_coal",
    output_1:  "share_of_total_costs_assigned_to_gas",
    output_2:  "share_of_total_costs_assigned_to_oil",
    output_3:  "share_of_total_costs_assigned_to_uranium",
    output_4:  "share_of_total_costs_assigned_to_sustainable",
    output_5:  "mixer_co2_reduction_from_1990",
    output_6:  "mixer_renewability",
    output_7:  "mixer_bio_footprint",
    output_8:  "mixer_net_energy_import",
    output_9:  "share_of_total_costs_assigned_to_sustainable_wind",
    output_10: "share_of_total_costs_assigned_to_sustainable_solar",
    output_11: "share_of_total_costs_assigned_to_sustainable_biomass",
    output_12: "mixer_total_costs"
  }
  
  PrimaryMixTable = {
    coal:      "share_of_total_costs_assigned_to_coal",
    gas:       "share_of_total_costs_assigned_to_gas",
    oil:       "share_of_total_costs_assigned_to_oil",
    nuclear:   "share_of_total_costs_assigned_to_uranium",
    renewable: "share_of_total_costs_assigned_to_sustainable"
  }
  
  SecondaryMixTable = {
    wind:    "share_of_total_costs_assigned_to_sustainable_wind",
    solar:   "share_of_total_costs_assigned_to_sustainable_solar",
    biomass: "share_of_total_costs_assigned_to_sustainable_biomass"
  }
  
  validates :name,  :presence => true
  # validates :email, :presence => true
  # disabled, client_side_validations has some issues with this validation
  # validates :age,   :numericality => true, :allow_blank => true
  
  # DEBT: one-liner
  # Outputs.keys.each {|key| validates key, :presence => true }
  validates :output_0,  :presence => true
  validates :output_1,  :presence => true
  validates :output_2,  :presence => true
  validates :output_3,  :presence => true
  validates :output_4,  :presence => true
  validates :output_5,  :presence => true
  validates :output_6,  :presence => true
  validates :output_7,  :presence => true
  validates :output_8,  :presence => true
  validates :output_9,  :presence => true
  validates :output_10, :presence => true
  validates :output_11, :presence => true
  validates :output_12, :presence => true
  
  scope :recent_first, order('created_at DESC')
  scope :public,       where(:public => true)
  scope :featured,     where(:featured => true)
  scope :averages,     where(:average => true)
  scope :user_created, where(:featured => false)
  scope :featured_first, order('featured DESC')
  scope :by_user, lambda {|q| where('name LIKE ?', "%#{q}%") unless q.blank? }
  scope :excluding, lambda{|s| where('id != ?', s)}
  
  attr_accessor :year, :accept_terms
  before_save :sanitize_age
  
  paginates_per 10
    
  def carrier_ratios
    {
      coal: output_0,
      gas: output_1,
      oil: output_2,
      nuclear: output_3,
      renewable: output_4
    }
  end

  def renewable_carrier_ratios
    {
      wind: output_9,
      solar: output_10,
      biomass: output_11
    }
  end
    
  def combined_carriers
    carrier_ratios.merge(renewable_carrier_ratios)
  end
    
  def total_amount
    val = output_12 || (output_0 + output_1 + output_2 + output_3 + output_4)
    val *= 1_000_000_000 if val < 1_000_000_000
    val
  end
  
  # forces reload
  def self.current!
    current(true)
  end
  
  # store in cache when needed
  def self.current(force = false)
    # DEBT: 
    # Rails.cache.delete('current_scenario') if force
    # @current_scenario = Rails.cache.fetch('current_scenario) do
    #   client = ApiClient.new.current_situation
    #   attributes = Options.inject({:year => 2011}) {|hsh, arr| key,val = arr; hsh.merge key => client[val]}
    #   new(attributes)
    # end
    @current_scenario = Rails.cache.read('current_scenario')
    if force || @current_scenario.nil?
      c = ApiClient.new.current_situation
      # DEBT: one-liner
      # settings = Options.inject({:year => 2011}) {|hsh, arr| key,val = arr; hsh.merge key => c[val]}
      @current_scenario = new(
        :output_0  => c["share_of_total_costs_assigned_to_coal"],
        :output_1  => c["share_of_total_costs_assigned_to_gas"],
        :output_2  => c["share_of_total_costs_assigned_to_oil"],
        :output_3  => c["share_of_total_costs_assigned_to_uranium"],
        :output_4  => c["share_of_total_costs_assigned_to_sustainable"],
        :output_5  => c["mixer_co2_reduction_from_1990"],
        :output_6  => c["mixer_renewability"],
        :output_7  => c["mixer_bio_footprint"],
        :output_8  => c["mixer_net_energy_import"],
        :output_9  => c["share_of_total_costs_assigned_to_sustainable_wind"],
        :output_10 => c["share_of_total_costs_assigned_to_sustainable_solar"],
        :output_11 => c["share_of_total_costs_assigned_to_sustainable_biomass"],
        :output_12 => c["mixer_total_costs"],
        :year      => 2011
      )
      Rails.cache.write('current_scenario', @current_scenario)
    end
    @current_scenario 
  rescue # some acceptable values, should the api request fail
    @current_scenario = self.acceptable_scenario
  end
  
  def sanitize_age
    self.age = nil if self.age.to_i == 0
  end
  
  # Returns plausible scenario if for any reason the API request fails
  def self.acceptable_scenario
    # DEBT: shouldn't this belong in Api::Client?
    new(
      :output_0  => 4135606319.8158274,    # coal
      :output_1  => 19712261358.58237,     # gas
      :output_2  => 15600440661.944386,    # oil
      :output_3  => 562037387.8724155,     # uranium
      :output_4  => 2695124317.5551677,    # sustainable      
      :output_5  => -0.005590499343000932, # mixer_co2_reduction_from_1990
      :output_6  => 0.05393912138004123,   # mixer_renewability
      :output_7  => 0.6045053247669468,    # mixer_bio_footprint
      :output_8  => 0.2477505720053616,    # mixer_net_energy_import
      :output_9  => 212589519.75315946,    # share_of_total_costs_assigned_to_sustainable_wind
      :output_10 => 2141265.8747384516,    # share_of_total_costs_assigned_to_sustainable_solar
      :output_11 => 2170862923.8200254,    # share_of_total_costs_assigned_to_sustainable_biomass
      :output_12 => 42.420507732497605,    # mixer_total_costs
      :year      => 2011
    )
  end
end
