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
#  year            :integer(4)
#  longitude       :float
#  latitude        :float
#

class Scenario < ActiveRecord::Base
  CurrentTitle = 'Current Scenario'

  has_many :answers, :class_name => 'ScenarioAnswer', :dependent => :destroy
  belongs_to :question_set

  accepts_nested_attributes_for :answers

  # Be careful, these values must match the dashboard items
  # We could store this mapping in the db, but let's keep things simple
  Outputs = {
    output_0:  "share_of_total_costs_assigned_to_coal",
    output_1:  "share_of_total_costs_assigned_to_gas",
    output_2:  "share_of_total_costs_assigned_to_oil",
    output_3:  "share_of_total_costs_assigned_to_nuclear",
    output_4:  "share_of_total_costs_assigned_to_renewables",
    output_5:  "mixer_reduction_of_co2_emissions_versus_1990",
    output_6:  "mixer_renewability",
    output_7:  "mixer_bio_footprint",
    output_8:  "mixer_net_energy_import",
    output_9:  "share_of_total_costs_assigned_to_wind",
    output_10: "share_of_total_costs_assigned_to_solar",
    output_11: "share_of_total_costs_assigned_to_biomass",
    output_12: "mixer_total_costs"
  }

  PrimaryTable = {
    coal:       "share_of_total_costs_assigned_to_coal",
    gas:        "share_of_total_costs_assigned_to_gas",
    oil:        "share_of_total_costs_assigned_to_oil",
    nuclear:    "share_of_total_costs_assigned_to_nuclear",
    renewables: "share_of_total_costs_assigned_to_renewables"
  }

  SecondaryTable = {
    wind:    "share_of_total_costs_assigned_to_wind",
    solar:   "share_of_total_costs_assigned_to_solar",
    biomass: "share_of_total_costs_assigned_to_biomass"
  }

  # The keys are used in the translation files
  DashboardTable = {
    co2_emissions: "mixer_reduction_of_co2_emissions_versus_1990",
    renewability:  "mixer_renewability",
    footprint:     "mixer_bio_footprint",
    energy_import: "mixer_net_energy_import"
  }

  CostsTable = {
    total_costs: "mixer_total_costs"
  }

  validates :name, :presence => true
  validates :question_set_id, :presence => true
  validates :etm_scenario_id, presence: true
  # validates :email, :presence => true
  # disabled, client_side_validations has some issues with this validation
  # validates :age,   :numericality => true, :allow_blank => true

  Outputs.keys.each {|key| validates key, :presence => true }
  validates :accept_terms, :acceptance => true

  scope :recent_first, order('created_at DESC')
  scope :public,       where(:public => true)
  scope :featured,     where(:featured => true)
  scope :not_featured, where(:featured => false)
  scope :averages,     where(:average => true)
  scope :not_average,  where(:average => false)
  scope :featured_first, order('featured DESC')
  scope :by_user, lambda {|q| where('name LIKE ?', "%#{q}%") unless q.blank? }
  scope :excluding, lambda{|s| where('id != ?', s)}

  attr_accessor :accept_terms
  before_save :sanitize_age

  paginates_per 10

  def carrier_ratios
    {
      coal: output_0,
      gas: output_1,
      oil: output_2,
      nuclear: output_3,
      renewables: output_4
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
    # Old scenarios used billions as unit
    val *= 1_000_000_000 if val < 1_000_000_000
    val
  end

  # forces reload
  def self.current!
    current(true)
  end

  # store in cache when needed
  def self.current(force = false)
    Rails.cache.delete('current_scenario') if force
    @current_scenario = Rails.cache.fetch('current_scenario') do
      c = ApiClient.new.current_situation
      attrs = {:year => 2011}
      Scenario::Outputs.each_pair {|output, gquery| attrs[output] = c[gquery]}
      new(attrs)
    end
  rescue # some acceptable values, should the api request fail
    @current_scenario = self.acceptable_scenario
  end

  def sanitize_age
    self.age = nil if self.age.to_i == 0
  end

  # Returns plausible scenario if for any reason the API request fails
  def self.acceptable_scenario
    new(
    :output_0  => 4135606319.8158274,    # coal
    :output_1  => 19712261358.58237,     # gas
    :output_2  => 15600440661.944386,    # oil
    :output_3  => 562037387.8724155,     # nuclear
    :output_4  => 2695124317.5551677,    # renewable
    :output_5  => -0.005590499343000932, # mixer_co2_reduction_from_1990
    :output_6  => 0.05393912138004123,   # mixer_renewability
    :output_7  => 0.6045053247669468,    # mixer_bio_footprint
    :output_8  => 0.2477505720053616,    # mixer_net_energy_import
    :output_9  => 212589519.75315946,    # share_of_total_costs_assigned_to_renewables_wind
    :output_10 => 2141265.8747384516,    # share_of_total_costs_assigned_to_renewables_solar
    :output_11 => 2170862923.8200254,    # share_of_total_costs_assigned_to_renewables_biomass
    :output_12 => 42.420507732497605,    # mixer_total_costs
    :year      => 2011
    )
  end

  def current_scenario?
    self.featured? && self.title == CurrentTitle
  end

  def has_coordinates?
    !latitude.blank? && !longitude.blank?
  end
end
