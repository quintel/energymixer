function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path  = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id = false;
  self.parameters = {};
    
  self.fetch_session_id = function() {
    if (self.session_id) {
      console.log("Using cached session key " + self.session_id);
      return self.session_id;
    }
    
    var url = self.base_path + "new.json"
    
    $.ajax({
      url: url,
      dataType: 'jsonp',
      success: function(data){
        var key = data.api_scenario.api_session_key;
        self.session_id = key;
        console.log("Fetched Session Key: " + key)
      },
      error: function(){
        alert('an error occured');
      }
    });
    return self.session_id;
  };
  
  self.base_path_with_session_id = function() {
    var url = self.base_path + self.fetch_session_id();
    return url;
  };
  
  self.get_results = function(res) {
    if(!res) res = ["co2_emission_total"];
    var url = self.base_path_with_session_id() + ".json";
    console.log(url);
    $.ajax({
      url: url,
      data: { result: res },
      dataType: 'jsonp',
      success: function(data){
        console.log("Got results");
        self.results = data;
        $("#response").html(JSON.stringify(data));        
      },
      error: function(){
        alert('an error occured');
      }
    });
    return self.results;
  };

  self.push_parameters = function() {
    var url = self.base_path_with_session_id() + ".json";
    console.log(url);
    $.ajax({
      url: url,
      data: { input: self.parameters },
      dataType: 'jsonp',
      success: function(data){
        console.log("Pushed parameters");
      },
      error: function(){
        alert('an error occured');
      }
    });
  };
    
  // merges in the common hash
  self.set_parameter = function(key, value) {
    self.parameters[key] = value;
    return self.parameters;
  };
  
  // will send the parameters and fetch results in a single step
  self.run = function(res) {
    self.process_form();
    if(!res) res = ["co2_emission_total"];
    var url = self.base_path_with_session_id() + ".json";
    console.log(url);
    $.ajax({
      url: url,
      data: { result: res, input: self.parameters },
      dataType: 'jsonp',
      success: function(data){
        console.log("Got results");
        self.results = data;
        $("#response").html(JSON.stringify(data));        
      },
      error: function(){
        alert('an error occured');
      }
    });    
  };
  
  self.property_map = {
    demand_households_replacement_of_existing_houses: 1,
    demand_households_efficiency_fridge_freezer: 6,
    costs_oil: 11,
    investment_costs_wind_onshore: 12,
    investment_costs_wind_offshore: 14,
    investment_costs_combustion_gas_plant: 16,
    investment_costs_combustion_oil_plant: 17,
    investment_costs_combustion_coal_plant: 18,
    investment_costs_combustion_biomass_plant: 19,
    demand_households_lighting_low_energy_light_bulb_share: 43,
    demand_households_lighting_light_emitting_diode_share: 44,
    demand_households_market_penetration_solar_panels: 47,
    demand_households_heating_solar_thermal_panels_share: 48,
    demand_households_heating_micro_chp_share: 51,
    demand_households_heating_electric_heater_share: 52,
    costs_coal: 57,
    costs_gas: 58,
    costs_biomass: 59,
    investment_costs_water_river: 114,
    investment_costs_water_mountains: 115,
    investment_costs_water_blue_energy: 116,
    om_costs_nuclear_nuclear_plant: 121,
    om_costs_wind_onshore: 126,
    om_costs_wind_offshore: 127,
    om_costs_water_river: 129,
    om_costs_water_blue_energy: 130,
    om_costs_water_mountains: 131,
    om_costs_earth_geothermal_electricity: 132,
    investment_costs_solar_solar_panels: 133,
    investment_costs_solar_concentrated_solar_power: 134,
    investment_costs_nuclear_nuclear_plant: 136,
    costs_co2: 137,
    costs_co2_free_allocation: 138,
    om_costs_co2_ccs: 139,
    investment_costs_co2_ccs: 140,
    demand_transport_cars: 141,
    demand_transport_trucks: 142,
    demand_transport_trains: 143,
    demand_transport_domestic_flights: 144,
    demand_transport_inland_navigation: 145,
    demand_transport_cars_electric_share: 146,
    demand_transport_cars_diesel_share: 147,
    demand_transport_cars_gasoline_share: 148,
    demand_transport_trucks_gasoline_share: 157,
    demand_transport_trucks_diesel_share: 158,
    demand_transport_trucks_electric_share: 159,
    demand_industry_electricity: 169,
    demand_industry_heat_from_fuels: 170,
    demand_transport_efficiency_electric_vehicles: 171,
    policy_area_onshore_land: 178,
    policy_area_onshore_coast: 179,
    om_costs_combustion_gas_plant: 180,
    om_costs_combustion_oil_plant: 181,
    om_costs_combustion_coal_plant: 182,
    om_costs_combustion_biomass_plant: 183,
    costs_uranium: 185,
    demand_transport_efficiency_combustion_engine_cars: 186,
    demand_transport_efficiency_ships: 187,
    demand_transport_efficiency_airplanes: 188,
    policy_area_roofs_for_solar_panels: 193,
    policy_area_land_for_solar_panels: 194,
    policy_area_land_for_csp: 195,
    policy_area_biomass: 196,
    policy_area_green_gas: 197,
    policy_sustainability_co2_emissions: 198,
    demand_industry_non_energetic_other: 202,
    demand_households_electricity_per_person: 203,
    demand_households_cooling_per_person: 204,
    demand_industry_non_energetic_oil: 205,
    policy_dependence_max_dependence: 206,
    policy_cost_electricity_cost: 207,
    policy_cost_total_energy_cost: 208,
    policy_grid_baseload_maximum: 210,
    policy_grid_intermittent_maximum: 211,
    policy_dependence_max_electricity_dependence: 212,
    demand_industry_electricity: 213,
    demand_industry_heat: 214,
    demand_industry_heating_gas_fired_heater_share: 216,
    demand_industry_heating_oil_fired_heater_share: 217,
    demand_industry_heating_coal_fired_heater_share: 218,
    demand_industry_heating_biomass_fired_heater_share: 219,
    demand_agriculture_electricity: 220,
    demand_agriculture_heat: 221,
    demand_agriculture_heating_oil_fired_heater_share: 223,
    demand_agriculture_heating_biomass_fired_heater_share: 225,
    demand_agriculture_heating_heat_pump_with_ts_share: 227,
    demand_agriculture_heating_geothermal_share: 228,
    demand_other_electricity: 229,
    demand_other_heat: 230,
    investment_costs_combustion_waste_incinerator: 231,
    om_costs_combustion_waste_incinerator: 232,
    policy_area_offshore: 233,
    policy_sustainability_renewable_percentage: 234,
    demand_transport_cars_lpg_share: 238,
    demand_transport_cars_compressed_gas_share: 239,
    demand_transport_trucks_compressed_gas_share: 240,
    demand_transport_efficiency_trains: 241,
    demand_households_heating_small_gas_chp_share: 242,
    demand_households_lighting_incandescent_share: 245,
    demand_agriculture_heating_gas_fired_heater_share: 246,
    investment_costs_earth_geothermal_electricity: 247,
    demand_households_heating_oil_fired_heater_share: 248,
    supply_number_of_pulverized_coal: 250,
    supply_number_of_pulverized_coal_ccs: 251,
    supply_number_of_coal_iggc: 253,
    supply_number_of_coal_igcc_ccs: 254,
    supply_number_of_coal_oxyfuel_ccs: 255,
    supply_number_of_gas_conventional: 256,
    supply_number_of_gas_ccgt: 257,
    supply_number_of_oil_fired_plant: 258,
    supply_number_of_nuclear_3rd_gen: 259,
    supply_electricity_green_gas_share: 260,
    supply_number_of_co_firing_coal: 261,
    supply_number_of_co_firing_gas: 262,
    supply_number_of_wind_onshore_land: 263,
    supply_number_of_wind_onshore_coast: 264,
    supply_number_of_wind_offshore: 265,
    supply_number_of_hydro_river: 266,
    supply_number_of_hydro_mountain: 267,
    supply_number_of_blue_energy: 268,
    supply_number_of_geothermal_electric: 270,
    supply_number_of_waste_incinerator: 271,
    supply_number_of_biomass_chp_fixed: 272,
    supply_number_of_micro_chp_fixed: 274,
    supply_number_of_small_chp_fixed: 275,
    supply_number_of_large_chp: 276,
    supply_number_of_coal_chp_fixed: 277,
    supply_number_of_micro_chp_fixed: 278,
    supply_number_of_small_gas_chp_fixed: 279,
    supply_number_of_large_gas_chp_fixed: 280,
    supply_number_of_gas_fired_heater_fixed: 281,
    supply_number_of_oil_fired_heater_fixed: 282,
    supply_number_of_coal_fired_heaterv: 283,
    supply_number_of_biomass_chp_fixed: 285,
    supply_number_of_bio_oil_chp_fixed: 286,
    supply_number_of_electric_heat_pump_fixed: 289,
    supply_number_of_solar_water_heater_fixed: 290,
    supply_number_of_geothermal_fixed: 291,
    supply_transport_diesel_share: 292,
    supply_transport_biodiesel_share: 293,
    supply_transport_gasoline_share: 294,
    supply_transport_bio_ethanol_share: 295,
    supply_transport_natural_gas_share: 296,
    supply_transport_bio_gas_share: 297,
    supply_number_of_solar_pv_plants: 298,
    supply_number_of_concentrated_solar_power: 299,
    supply_number_of_solar_pv_roofs_fixed: 313,
    supply_number_of_coal_chp_fixed: 314,
    supply_number_of_coal_conventional: 315,
    supply_number_of_coal_lignite: 316,
    demand_households_heating_gas_fired_heat_pump_share: 317,
    demand_other_number_of_small_gas_chp: 321,
    demand_industry_number_of_gas_chp: 322,
    demand_industry_number_of_biomass_chp: 324,
    demand_agriculture_number_of_small_gas_chp: 325,
    demand_industry_heating_combined_heat_power_share: 326,
    demand_agriculture_heating_combined_heat_power_share: 327,
    demand_transport_efficiency_combustion_engine_trucks: 328,
    demand_households_hot_water_gas_combi_heater_share: 333,
    demand_households_number_of_inhabitants: 335,
    demand_households_insulation_level_old_houses: 336,
    demand_households_insulation_level_new_houses: 337,
    demand_households_heating_heat_pump_ground_share: 338,
    demand_households_heating_heat_pump_add_on_share: 339,
    demand_households_heating_pellet_stove_share: 340,
    demand_households_heating_heat_network_share: 341,
    demand_households_heating_biomass_chp_share: 343,
    demand_households_heating_geothermal_share: 344,
    demand_households_hot_water_gas_water_heater_share: 346,
    demand_households_hot_water_electric_boiler_share: 347,
    demand_households_hot_water_solar_water_heater_share: 348,
    demand_households_cooling_heat_pump_ground_share: 351,
    demand_households_cooling_gas_fired_heat_pump_share: 352,
    demand_households_cooling_airconditioning_share: 353,
    demand_households_cooking_gas_share: 354,
    demand_households_cooking_electric_share: 355,
    demand_households_cooking_halogen_share: 356,
    demand_households_cooking_induction_share: 357,
    demand_households_efficiency_dish_washer: 359,
    demand_households_efficiency_vacuum_cleaner: 360,
    demand_households_efficiency_washing_machine: 361,
    demand_households_efficiency_dryer: 362,
    demand_households_efficiency_television: 363,
    demand_households_efficiency_computer_media: 364,
    demand_households_behavior_standby_killer_turn_off_appliances: 366,
    demand_households_behavior_turn_off_the_light: 368,
    demand_households_behavior_close_windows_turn_off_heating: 370,
    demand_households_efficiency_low_temperature_washing: 371,
    demand_households_heat_per_person: 372,
    demand_households_hot_water_per_person: 373,
    demand_households_cooling_heat_pump_with_ts_share: 374,
    demand_households_heating_heat_pump_with_ts_share: 375,
    demand_buildings_number_of_buildings: 376,
    demand_buildings_electricity_per_student_employee: 377,
    demand_buildings_heat_per_employee_student: 378,
    demand_buildings_insulation_level_schools: 381,
    demand_buildings_insulation_level_offices: 382,
    demand_buildings_heating_gas_fired_heater_share: 383,
    demand_buildings_heating_biomass_chp_share: 385,
    demand_buildings_heating_small_gas_chp_share: 386,
    demand_buildings_heating_electric_heater_share: 387,
    demand_buildings_heating_heat_network_share: 388,
    demand_buildings_heating_solar_thermal_panels_share: 389,
    demand_buildings_heating_gas_fired_heat_pump_share: 390,
    demand_buildings_cooling_gas_fired_heat_pump_share: 391,
    demand_buildings_cooling_heat_pump_with_ts_share: 392,
    demand_buildings_cooling_airconditioning_share: 393,
    demand_buildings_heating_heat_pump_with_ts_share: 394,
    demand_buildings_ventilation_rate: 395,
    demand_buildings_recirculation: 396,
    demand_buildings_waste_heat_recovery: 397,
    demand_buildings_appliances_efficiency: 398,
    demand_buildings_lighting_fluorescent_tube_conventional_share: 400,
    demand_buildings_lighting_fluorescent_tube_high_performance_share: 401,
    demand_buildings_lighting_led_tube_share: 402,
    demand_buildings_lighting_motion_detection: 403,
    demand_buildings_lighting_daylight_dependent_control: 404,
    demand_buildings_market_penetration_solar_panels: 405,
    demand_buildings_heating_biomass_fired_heater_share: 406,
    demand_buildings_cooling_per_student_employee: 408,
    demand_buildings_heating_oil_fired_heater_share: 409,
    demand_households_heating_coal_fired_heater_share: 411,
    demand_households_efficiency_other: 412,
    supply_number_of_nuclear_conventional: 413,
    supply_number_of_biomass_fired_heater_fixed: 414,
    supply_number_of_gas_fired_heat_pump_fixed: 415,
    supply_number_of_gas_ccgt_ccs: 416,
    demand_households_hot_water_heat_pump_ground_share: 420,
    demand_households_hot_water_heat_network_share: 421,
    supply_number_of_lignite_chp: 422,
    supply_transport_planes_fossil_fuel_share: 423,
    supply_transport_planes_bio_based_fuel_share: 424,
    supply_transport_ships_fossil_fuel_share: 425,
    supply_transport_ships_bio_based_fuel_share: 426,
    demand_transport_trains_coal_share: 427,
    demand_transport_trains_diesel_share: 428,
    demand_transport_trains_electric_share: 429,
    supply_number_of_coal_fired_heater_district: 430,
    supply_number_of_biomass_fired_heater_district: 431,
    supply_number_of_gas_fired_heater_district: 432,
    supply_number_of_waste_fired_heater_district: 433,
    demand_households_hot_water_oil_fired_heater_share: 435,
    demand_households_cooking_biomass_share: 436,
    supply_number_of_lignite_chp_fixed: 437,
    demand_households_hot_water_fuel_cell_share: 439,
    demand_households_heating_gas_fired_heater_share: 441,
    demand_households_hot_water_coal_fired_heater_hotwater_share: 443,
    demand_households_hot_water_biomass_heater_share: 444,
    demand_households_hot_water_micro_chp_share: 445,
    demand_households_hot_water_gas_fired_heater_share: 446,
    policy_cost_energy_use: 447,
    demand_agriculture_industry_demand_growth: 448,
    supply_number_of_waste_incinerator: 449,
    demand_households_label_a: 450,
    demand_households_label_b: 451,
    demand_households_label_c: 452,
    demand_households_label_d: 453,
    demand_households_label_e: 454,
    demand_households_label_f: 455,
    demand_households_label_g: 456,
    demand_buildings_epc0: 457,
    demand_buildings_epc0_05: 458,
    demand_buildings_epc05_10: 459,
    demand_buildings_epc10_15: 460,
    demand_buildings_epc15_20: 461,
    demand_buildings_epc20_25: 462,
    demand_buildings_epc25: 463,
    demand_buildings_label_a: 464,
    demand_buildings_label_b: 466,
    demand_buildings_label_c: 467,
    demand_buildings_label_d: 468,
    demand_buildings_label_e: 469,
    demand_buildings_label_f: 470,
    demand_buildings_label_g: 471,
    demand_households_epc0: 472,
    demand_households_epc0_02: 473,
    demand_households_epc02_04: 474,
    demand_households_epc04_06: 475,
    demand_households_epc06_08: 476,
    demand_households_epc08_10: 477,
    demand_households_epc1: 478,
    demand_transport_cars: 479,
    demand_transport_public_transport: 480,
    demand_transport_bike: 481,
    demand_buildings_electricity_use: 482,
    demand_buildings_gas_use: 483,
    demand_transport_bio_fuels: 485,
    demand_transport_electric: 486,
    demand_transport_fossil_fuels: 487,
    supply_green_gas_total_share: 488,
    supply_natural_gas_total_share: 489
  };
  
  self.property_matrix = {
    q1: {
      1: {
        cost_combustion_gas: 1,
        cost_combustion_oil: 1,
        cost_combustion_coal: 1,
        cost_combustion_biomass: 1
      },
      2: {
        cost_combustion_gas: 1.25,
        cost_combustion_oil: 1.25,
        cost_combustion_coal: 1.25,
        cost_combustion_biomass: 1.25
      },
      3: {
        cost_combustion_gas: 0.75,
        cost_combustion_oil: 0.75,
        cost_combustion_coal: 0.75,
        cost_combustion_biomass: 0.75
      }
    },
    q2: {
      1: {
        // it would be nice to set the default values
      },
      2: {
        demand_households_insulation_level_old_houses: 2,
        demand_households_insulation_level_new_houses: 5,
        demand_buildings_insulation_level_schools: 2,
        demand_buildings_insulation_level_offices: 3.2,
        demand_transport_combustion_engine_cars:2, 
        demand_industry_electricity: 1,
        demand_industry_heat_from_fuels: 1,
        supply_electricity_renewable_green_gas_total_share: 3 // Not sure about this
      },
      3: {
        demand_households_insulation_level_old_houses: 3,
        demand_households_insulation_level_new_houses: 6,
        demand_buildings_insulation_level_schools: 3,
        demand_buildings_insulation_level_offices: 4.2,
        demand_transport_combustion_engine_cars: 3,
        demand_industry_electricity: 2,
        demand_industry_heat_from_fuels: 2,
        supply_electricity_renewable_natural_gas_share: 90,
        supply_electricity_renewable_green_gas_total_share: 10,
        supply_electricity_renewable_onshore_land: 2000,
        supply_electricity_renewable_onshore_coast: 200,
        supply_electricity_renewable_offshore: 2000
      }
    }
  };
  
  self.process_form = function() {
    console.log("Processing form elements");
    
    $.each(["q1"], function(index, question_name) {
      var field_selector = "input[name=" + question_name + "]:checked";
      var selected_option = $(field_selector).val();
      if (!selected_option) return;
      $.each(self.property_matrix[question_name][selected_option], function(param_key, val) {
        var param_id = self.property_map[param_key];
        self.parameters[param_id] = val;
      });
    });

    return self.parameters;
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}


$(function() {
  m = new Mixer();
  
  
  
  // interface
  $("form").submit(function() {
    m.run();
    return false;
  });
  
  $("#tabs").tabs();
  $("input:submit").button();
});
