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
#

class Scenario < ActiveRecord::Base
  MaxAmount = 100_000_000_000
  
  has_many :answers, :class_name => 'ScenarioAnswer', :dependent => :destroy

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
    output_8: "energy_dependence",
    output_9: "costs_share_of_sustainable_wind",
    output_10: "costs_share_of_sustainable_solar",
    output_11: "costs_share_of_sustainable_biomass"
  }
  
  PrimaryMixTable = {
    coal: {
     gquery: "costs_share_of_coal",
     unit: "Mln. Euro",
     label: I18n.t('coal'),
     css_class: "coal"
    },
    gas: {
     gquery: "costs_share_of_gas",
     label: I18n.t('gas'),
     css_class: "gas"
    }, 
    oil: {
     gquery: "costs_share_of_oil",
     label: I18n.t('oil'),
     css_class: "oil"
    },
    nuclear: {
     gquery: "costs_share_of_uranium",
     label: I18n.t('nuclear'),
     css_class: "nuclear"

    }, 
    renewable: {
     gquery: "costs_share_of_sustainable",
     label: I18n.t('sustainable'),
     css_class: "renewable"       
    }
  }
  
  SecondaryMixTable = {
    wind: {
      gquery: "costs_share_of_sustainable_wind",
      label: I18n.t('wind'),
      css_class: "wind"       
    },
    solar: {
      gquery: "costs_share_of_sustainable_solar",
      label: I18n.t('solar'),
      css_class: "solar"       
    },
    biomass: {
      gquery: "costs_share_of_sustainable_biomass",
      label: I18n.t('biomass'),
      css_class: "renewable"       
    }
  }
  
  validates :name,  :presence => true
  validates :email, :presence => true
  # disabled, client_side_validations has some issues with this validation
  # validates :age,   :numericality => true, :allow_blank => true
  validates :output_0, :presence => true
  validates :output_1, :presence => true
  validates :output_2, :presence => true
  validates :output_3, :presence => true
  validates :output_4, :presence => true
  validates :output_5, :presence => true
  validates :output_6, :presence => true
  validates :output_7, :presence => true
  validates :output_8, :presence => true
  validates :output_9, :presence => true
  validates :output_10, :presence => true
  validates :output_11, :presence => true
  validates :accept_terms, :acceptance => true
  
  scope :recent_first, order('created_at DESC')
  scope :public,       where(:public => true)
  scope :featured,     where(:featured => true)
  scope :user_created, where(:featured => false)
  scope :featured_first, order('featured DESC')
  # shall we use SOLR/TS/?
  scope :by_user, lambda {|q| where('name LIKE ?', "%#{q}%")}
  scope :excluding, lambda{|s| where('id != ?', s)}
  
  attr_accessor :year, :accept_terms
  before_save :sanitize_age
  
  paginates_per 6
    
  def carriers
    {
      coal:      { label: I18n.t('coal'),      amount: output_0, ratio: output_0 / total_amount },
      gas:       { label: I18n.t('gas'),       amount: output_1, ratio: output_1 / total_amount },
      oil:       { label: I18n.t('oil'),       amount: output_2, ratio: output_2 / total_amount },
      nuclear:   { label: I18n.t('nuclear'),   amount: output_3, ratio: output_3 / total_amount },
      renewable: { label: I18n.t('renewable'), amount: output_4, ratio: output_4 / total_amount }
    }
  end

  def renewable_carriers
    self.output_9  ||= 0
    self.output_10 ||= 0
    self.output_11 ||= 0
    renewable_total = output_4 || 0.000001 # prevent division by zero
    {
      wind:      { label: I18n.t('wind'),      amount: output_9, ratio: output_9 / renewable_total },
      solar:     { label: I18n.t('solar'),     amount: output_10, ratio: output_10 / renewable_total },
      biomass:   { label: I18n.t('biomass'),   amount: output_11, ratio: output_11 / renewable_total }
    }
  end
  
  # Ugly
  def total_amount
    output_0 + output_1 + output_2 + output_3 + output_4
  end
  
  def self.current
    c = ApiClient.new.current_situation
    @current_scenario ||= new(
      :output_0  => c["costs_share_of_coal"],
      :output_1  => c["costs_share_of_gas"],
      :output_2  => c["costs_share_of_oil"],
      :output_3  => c["costs_share_of_uranium"],
      :output_4  => c["costs_share_of_sustainable"],
      :output_5  => c["co2_emission_final_demand_to_1990_in_percent"],
      :output_6  => c["share_of_renewable_energy"],
      :output_7  => c["area_footprint_per_nl"],
      :output_8  => c["energy_dependence"],
      :output_9  => c["costs_share_of_sustainable_wind"],
      :output_10 => c["costs_share_of_sustainable_solar"],
      :output_11 => c["costs_share_of_sustainable_biomass"],
      :year      => 2011
    )
    
  rescue
    @current_scenario ||= new(
      :output_0  => 4135606319.8158274, # coal
      :output_1  => 19712261358.58237,  # gas
      :output_2  => 15600440661.944386, # oil
      :output_3  => 562037387.8724155,  # uranium
      :output_4  => 2695124317.5551677, # sustainable      
      :output_5  => -0.005590499343000932, #
      :output_6  => 0.05393912138004123, #
      :output_7  => 0.6045053247669468, #
      :output_8  => 0.2477505720053616, #
      :output_9  => 212589519.75315946,
      :output_10 => 2141265.8747384516,
      :output_11 => 2170862923.8200254,
      :year      => 2011
    )
  end
  
  def sanitize_age
    self.age = nil if self.age.to_i == 0
  end
end
