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
  
  validate :check_valid_key
  
  attr_accessible :value, :slider_id, :key

  def key
    KEYS[slider_id]
  end
  
  def key=(value)
    self.slider_id = KEYS.invert[value] rescue nil
  end
  
  def check_valid_key
    errors.add(:key, 'invalid code') unless slider_id    
  end
  
  KEYS = {
    1   => "households_replacement_of_existing_houses",
    6   => "households_efficiency_fridge_freezer",
    11  => "costs_oil",
    12  => "investment_costs_wind_onshore",
    14  => "investment_costs_wind_offshore",
    16  => "investment_costs_combustion_gas_plant",
    17  => "investment_costs_combustion_oil_plant",
    18  => "investment_costs_combustion_coal_plant",
    19  => "investment_costs_combustion_biomass_plant",
    43  => "households_lighting_low_energy_light_bulb_share",
    44  => "households_lighting_light_emitting_diode_share",
    47  => "households_market_penetration_solar_panels",
    48  => "households_heating_solar_thermal_panels_share",
    51  => "households_heating_micro_chp_share",
    52  => "households_heating_electric_heater_share",
    57  => "costs_coal",
    58  => "costs_gas",
    59  => "costs_biomass",
    114 => "investment_costs_water_river",
    115 => "investment_costs_water_mountains",
    116 => "investment_costs_water_blue_energy",
    121 => "om_costs_nuclear_nuclear_plant",
    126 => "om_costs_wind_onshore",
    127 => "om_costs_wind_offshore",
    129 => "om_costs_water_river",
    130 => "om_costs_water_blue_energy",
    131 => "om_costs_water_mountains",
    132 => "om_costs_earth_geothermal_electricity",
    133 => "investment_costs_solar_solar_panels",
    134 => "investment_costs_solar_concentrated_solar_power",
    136 => "investment_costs_nuclear_nuclear_plant",
    137 => "costs_co2",
    138 => "costs_co2_free_allocation",
    139 => "om_costs_co2_ccs",
    140 => "investment_costs_co2_ccs",
    141 => "transport_cars",
    142 => "transport_trucks",
    143 => "transport_trains",
    144 => "transport_domestic_flights",
    145 => "transport_inland_navigation",
    146 => "transport_cars_electric_share",
    147 => "transport_cars_diesel_share",
    148 => "transport_cars_gasoline_share",
    157 => "transport_trucks_gasoline_share",
    158 => "transport_trucks_diesel_share",
    159 => "transport_trucks_electric_share",
    169 => "industry_efficiency_electricity",
    170 => "industry_heat_from_fuels",
    171 => "transport_efficiency_electric_vehicles",
    178 => "policy_area_onshore_land",
    179 => "policy_area_onshore_coast",
    180 => "om_costs_combustion_gas_plant",
    181 => "om_costs_combustion_oil_plant",
    182 => "om_costs_combustion_coal_plant",
    183 => "om_costs_combustion_biomass_plant",
    185 => "costs_uranium",
    186 => "transport_efficiency_combustion_engine_cars",
    187 => "transport_efficiency_ships",
    188 => "transport_efficiency_airplanes",
    193 => "policy_area_roofs_for_solar_panels",
    194 => "policy_area_land_for_solar_panels",
    195 => "policy_area_land_for_csp",
    196 => "policy_area_biomass",
    197 => "policy_area_green_gas",
    198 => "policy_sustainability_co2_emissions",
    202 => "industry_non_energetic_other_demand",
    203 => "households_electricity_demand_per_person",
    204 => "households_cooling_demand_per_person",
    205 => "industry_non_energetic_oil_demand",
    206 => "policy_dependence_max_dependence",
    207 => "policy_cost_electricity_cost",
    208 => "policy_cost_total_energy_cost",
    210 => "policy_grid_baseload_maximum",
    211 => "policy_grid_intermittent_maximum",
    212 => "policy_dependence_max_electricity_dependence",
    213 => "industry_electricity_demand",
    214 => "industry_heat_demand",
    216 => "industry_heating_gas_fired_heater_share",
    217 => "industry_heating_oil_fired_heater_share",
    218 => "industry_heating_coal_fired_heater_share",
    219 => "industry_heating_biomass_fired_heater_share",
    220 => "agriculture_electricity_demand",
    221 => "agriculture_heat_demand",
    223 => "agriculture_heating_oil_fired_heater_share",
    225 => "agriculture_heating_biomass_fired_heater_share",
    227 => "agriculture_heating_heat_pump_with_ts_share",
    228 => "agriculture_heating_geothermal_share",
    229 => "other_electricity_demand",
    230 => "other_heat_demand",
    231 => "investment_costs_combustion_waste_incinerator",
    232 => "om_costs_combustion_waste_incinerator",
    233 => "policy_area_offshore",
    234 => "policy_sustainability_renewable_percentage",
    238 => "transport_cars_lpg_share",
    239 => "transport_cars_compressed_gas_share",
    240 => "transport_trucks_compressed_gas_share",
    241 => "transport_efficiency_trains",
    242 => "households_heating_small_gas_chp_share",
    245 => "households_lighting_incandescent_share",
    246 => "agriculture_heating_gas_fired_heater_share",
    247 => "investment_costs_earth_geothermal_electricity",
    248 => "households_heating_oil_fired_heater_share",
    250 => "number_of_pulverized_coal",
    251 => "number_of_pulverized_coal_ccs",
    253 => "number_of_coal_iggc",
    254 => "number_of_coal_igcc_ccs",
    255 => "number_of_coal_oxyfuel_ccs",
    256 => "number_of_gas_conventional",
    257 => "number_of_gas_ccgt",
    258 => "number_of_oil_fired_plant",
    259 => "number_of_nuclear_3rd_gen",
    260 => "electricity_green_gas_share",
    261 => "number_of_co_firing_coal",
    262 => "number_of_co_firing_gas",
    263 => "number_of_wind_onshore_land",
    264 => "number_of_wind_onshore_coast",
    265 => "number_of_wind_offshore",
    266 => "number_of_hydro_river",
    267 => "number_of_hydro_mountain",
    268 => "number_of_blue_energy",
    270 => "number_of_geothermal_electric",
    271 => "number_of_waste_incinerator",
    272 => "number_of_biomass_chp_fixed",
    274 => "number_of_micro_chp_fixed",
    275 => "number_of_small_chp_fixed",
    276 => "number_of_large_chp",
    277 => "number_of_coal_chp_fixed",
    278 => "supply_fossil_heat_micro_chp",
    279 => "number_of_small_gas_chp_fixed",
    280 => "number_of_large_gas_chp_fixed",
    281 => "number_of_gas_fired_heater_fixed",
    282 => "number_of_oil_fired_heater_fixed",
    283 => "number_of_coal_fired_heaterv",
    285 => "supply_renewable_heat_biomass_chp",
    286 => "number_of_bio_oil_chp_fixed",
    289 => "number_of_electric_heat_pump_fixed",
    290 => "number_of_solar_water_heater_fixed",
    291 => "number_of_geothermal_fixed",
    292 => "transport_diesel_share",
    293 => "transport_biodiesel_share",
    294 => "transport_gasoline_share",
    295 => "transport_bio_ethanol_share",
    296 => "transport_natural_gas_share",
    297 => "transport_bio_gas_share",
    298 => "number_of_solar_pv_plants",
    299 => "number_of_concentrated_solar_power",
    313 => "number_of_solar_pv_roofs_fixed",
    314 => "supply_electricity_coal_chp",
    315 => "number_of_coal_conventional",
    316 => "number_of_coal_lignite",
    317 => "households_heating_gas_fired_heat_pump_share",
    321 => "other_number_of_small_gas_chp",
    322 => "industry_number_of_gas_chp",
    324 => "industry_number_of_biomass_chp",
    325 => "agriculture_number_of_small_gas_chp",
    326 => "industry_heating_combined_heat_power_share",
    327 => "agriculture_heating_combined_heat_power_share",
    328 => "transport_efficiency_combustion_engine_trucks",
    333 => "households_hot_water_gas_combi_heater_share",
    335 => "households_number_of_inhabitants",
    336 => "households_insulation_level_old_houses",
    337 => "households_insulation_level_new_houses",
    338 => "households_heating_heat_pump_ground_share",
    339 => "households_heating_heat_pump_add_on_share",
    340 => "households_heating_pellet_stove_share",
    341 => "households_heating_heat_network_share",
    343 => "households_heating_biomass_chp_share",
    344 => "households_heating_geothermal_share",
    346 => "households_hot_water_gas_water_heater_share",
    347 => "households_hot_water_electric_boiler_share",
    348 => "households_hot_water_solar_water_heater_share",
    351 => "households_cooling_heat_pump_ground_share",
    352 => "households_cooling_gas_fired_heat_pump_share",
    353 => "households_cooling_airconditioning_share",
    354 => "households_cooking_gas_share",
    355 => "households_cooking_electric_share",
    356 => "households_cooking_halogen_share",
    357 => "households_cooking_induction_share",
    359 => "households_efficiency_dish_washer",
    360 => "households_efficiency_vacuum_cleaner",
    361 => "households_efficiency_washing_machine",
    362 => "households_efficiency_dryer",
    363 => "households_efficiency_television",
    364 => "households_efficiency_computer_media",
    366 => "households_behavior_standby_killer_turn_off_appliances",
    368 => "households_behavior_turn_off_the_light",
    370 => "households_behavior_close_windows_turn_off_heating",
    371 => "households_efficiency_low_temperature_washing",
    372 => "households_heat_demand_per_person",
    373 => "households_hot_water_demand_per_person",
    374 => "households_cooling_heat_pump_with_ts_share",
    375 => "households_heating_heat_pump_with_ts_share",
    376 => "buildings_number_of_buildings",
    377 => "buildings_electricity_per_student_employee",
    378 => "buildings_heat_per_employee_student",
    381 => "buildings_insulation_level_schools",
    382 => "buildings_insulation_level_offices",
    383 => "buildings_heating_gas_fired_heater_share",
    385 => "buildings_heating_biomass_chp_share",
    386 => "buildings_heating_small_gas_chp_share",
    387 => "buildings_heating_electric_heater_share",
    388 => "buildings_heating_heat_network_share",
    389 => "buildings_heating_solar_thermal_panels_share",
    390 => "buildings_heating_gas_fired_heat_pump_share",
    391 => "buildings_cooling_gas_fired_heat_pump_share",
    392 => "buildings_cooling_heat_pump_with_ts_share",
    393 => "buildings_cooling_airconditioning_share",
    394 => "buildings_heating_heat_pump_with_ts_share",
    395 => "buildings_ventilation_rate",
    396 => "buildings_recirculation",
    397 => "buildings_waste_heat_recovery",
    398 => "buildings_appliances_efficiency",
    400 => "buildings_lighting_fluorescent_tube_conventional_share",
    401 => "buildings_lighting_fluorescent_tube_high_performance_share",
    402 => "buildings_lighting_led_tube_share",
    403 => "buildings_lighting_motion_detection",
    404 => "buildings_lighting_daylight_dependent_control",
    405 => "buildings_market_penetration_solar_panels",
    406 => "buildings_heating_biomass_fired_heater_share",
    408 => "buildings_cooling_per_student_employee",
    409 => "buildings_heating_oil_fired_heater_share",
    411 => "households_heating_coal_fired_heater_share",
    412 => "households_efficiency_other",
    413 => "number_of_nuclear_conventional",
    414 => "number_of_biomass_fired_heater_fixed",
    415 => "number_of_gas_fired_heat_pump_fixed",
    416 => "number_of_gas_ccgt_ccs",
    420 => "households_hot_water_heat_pump_ground_share",
    421 => "households_hot_water_heat_network_share",
    422 => "number_of_lignite_chp",
    423 => "transport_planes_fossil_fuel_share",
    424 => "transport_planes_bio_based_fuel_share",
    425 => "transport_ships_fossil_fuel_share",
    426 => "transport_ships_bio_based_fuel_share",
    427 => "transport_trains_coal_share",
    428 => "transport_trains_diesel_share",
    429 => "transport_trains_electric_share",
    430 => "number_of_coal_fired_heater_district",
    431 => "number_of_biomass_fired_heater_district",
    432 => "number_of_gas_fired_heater_district",
    433 => "number_of_waste_fired_heater_district",
    435 => "households_hot_water_oil_fired_heater_share",
    436 => "households_cooking_biomass_share",
    437 => "number_of_lignite_chp_fixed",
    439 => "households_hot_water_fuel_cell_share",
    441 => "households_heating_gas_fired_heater_share",
    443 => "households_hot_water_coal_fired_heater_hotwater_share",
    444 => "households_hot_water_biomass_heater_share",
    445 => "households_hot_water_micro_chp_share",
    446 => "households_hot_water_gas_fired_heater_share",
    447 => "policy_cost_energy_use",
    448 => "industry_demand",
    449 => "supply_electricity_waste_incinerator",
    488 => "green_gas_total_share",
    489 => "natural_gas_total_share",
    490 => "mw_of_nuclear_3rd_gen",
    491 => "mw_of_pulverized_coal",
    492 => "mw_of_conventional",
    494 => "mw_of_onshore_land",
    495 => "mw_of_onshore_coast",
    496 => "mw_of_offshore",
    497 => "mw_of_river",
    498 => "mw_of_geothermal_electric",
    499 => "mw_of_waste_incinerator",
    500 => "mw_of_solar_pv_roofs",
    501 => "mw_of_solar_pv_plants",
    502 => "mw_of_concentrated_solar_power",
    503 => "mw_of_pulverized_coal_ccs",
    504 => "mw_of_coal_iggc",
    505 => "mw_of_coal_igcc_ccs",
    506 => "mw_of_coal_conventional",
    507 => "mw_of_coal_oxyfuel_ccs",
    508 => "mw_of_coal_lignite",
    509 => "mw_of_electricity_coal_chp",
    510 => "mw_of_gas_ccgt",
    511 => "mw_of_gas_ccgt_ccs",
    512 => "mw_of_electricity_small_chp",
    513 => "mw_of_electricity_micro_chp",
    514 => "mw_of_oil_fired_plant",
    515 => "mw_of_nuclear_conventional",
    516 => "mw_of_electricity_large_gas_chp",
    517 => "mw_of_co_firing_coal",
    518 => "mw_of_co_firing_gas",
    519 => "mw_of_electricity_biomass_chp",
    520 => "mw_of_blue_energy",
    521 => "mw_of_heat_coal_chp_fixed",
    522 => "mw_of_heat_micro_chp_fixed",
    523 => "mw_of_heat_large_gas_chp_fixed",
    525 => "mw_of_heat_small_chp_fixed",
    527 => "mw_of_heat_lignite_chp_fixed",
    528 => "mw_of_heat_gas_fired_heater",
    529 => "mw_of_heat_oil_fired_heater",
    530 => "mw_of_heat_coal_fired_heater",
    531 => "mw_of_heat_gas_fired_heat_pump",
    532 => "mw_of_heat_coal_fired_heater_district",
    533 => "mw_of_heat_gas_fired_heater_district",
    534 => "mw_of_heat_waste_fired_heater_district",
    535 => "mw_of_heat_biomass_chp_fixed",
    536 => "mw_of_heat_bio_oil_chp_fixed",
    537 => "mw_of_heat_biomass_fired_heater_fixed",
    538 => "mw_of_heat_biomass_fired_heater_district",
    539 => "mw_of_heat_electric_heat_pump_fixed",
    540 => "mw_of_heat_geothermal_fixed",
    541 => "mw_of_heat_solar_water_heater_fixed",
    544 => "mw_of_heat_other_small_gas_chp",
    545 => "mw_of_heat_industry_gas_chp",
    546 => "mw_of_heat_industry_biomass_chp",
    547 => "mw_of_heat_agriculture_mall_gas_chp"
  }  
end

