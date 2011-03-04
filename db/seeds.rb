# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Question.destroy_all

@questions = [
  {
    question: "Benzine, gas en elektriciteit",
    answers: [
      {
        short: "Blijven even duur",
        long: "",
        inputs: [
          { id: 58, value: 1, key: 'costs_combustion_gas' },
          { id: 11, value: 1, key: 'costs_combustion_oil' },
          { id: 57, value: 1, key: 'costs_combustion_coal' },
          { id: 59, value: 1, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Worden duurder",
        long: "fosiele brandstoffen worden 25% duurder",
        inputs: [
          { id: 58, value: 1.25, key: 'costs_combustion_gas' },
          { id: 11, value: 1.25, key: 'costs_combustion_oil' },
          { id: 57, value: 1.25, key: 'costs_combustion_coal' },
          { id: 59, value: 1.25, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Worden goedkoper",
        long: "fosiele brandstoffen worden 25% goedkoper",
        inputs: [
          { id: 58, value: 0.75, key: 'costs_combustion_gas' },
          { id: 11, value: 0.75, key: 'costs_combustion_oil' },
          { id: 57, value: 0.75, key: 'costs_combustion_coal' },
          { id: 59, value: 0.75, key: 'costs_combustion_biomass' }
        ]
      }
    ]
  },
  
  {
    question: "De Nederlandse aardgasvelden raken geleidelijk leger, de eigen aardgasproductie neemt af. Om voldoende energie beschikbaar te hebben (equivalent van ongeveer 20miljard M3 aardgas), moet Nederland deze energie.",
    answers: [
      {
        short: "Importeren in de vorm van aardgas via pijplijnen en LNG in schepen",
        long: "Er verandert verder niets bij deze keuze",
        inputs: []
      },
      {
        short: "De helft importeren en de helft de helft oplossen met energiebesparing",
        long: "20m3 Nederlands aardgas (1m3 = 35.17 MJ) is 703 PJ. Dus ongeveer 350PJ besparen.  Dit doen door huizen en gebouwen dubbel zo goed te isoleren",
        inputs: [
          { id: 336, value: 2, key: 'demand_households_insulation_level_old_houses' },
          { id: 337, value: 5, key: 'demand_households_insulation_level_new_houses' },
          { id: 381, value: 2, key: 'demand_buildings_insulation_level_schools' },
          { id: 382, value: 3.2, key: 'demand_buildings_insulation_level_offices' },
          { id: 186, value: 2, key: 'demand_transport_combustion_engine_cars' },
          { id: 169, value: 1, key: 'demand_industry_electricity' },
          { id: 170, value: 1, key: 'demand_industry_heat_from_fuels' }
        ]
      },
      {
        short: "De helft opwekken met eigen energie uit biomassa, zon en wind en de helft uit energiebesparing halen",
        long: "Dezelfde instellingen van 1b maar tevens de volgende maatregelen aan de aanbodkant (350PJ hernieuwbaar inzetten verdeeld over biomassa zon en wind",
        inputs: [
          { id: 336, value: 3, key: 'demand_households_insulation_level_old_houses' },
          { id: 337, value: 6, key: 'demand_households_insulation_level_new_houses' },
          { id: 381, value: 3, key: 'demand_buildings_insulation_level_schools' },
          { id: 382, value: 4.2, key: 'demand_buildings_insulation_level_offices' },
          { id: 186, value: 3, key: 'demand_transport_combustion_engine_cars' },
          { id: 169, value: 2, key: 'demand_industry_electricity' },
          { id: 170, value: 2, key: 'demand_industry_heat_from_fuels' },
          { id: 489, value: 90, key: 'supply_electricity_renewable_natural_gas_share' },
          { id: 488, value: 10, key: 'supply_electricity_renewable_green_gas_total_share' },
          { id: 263, value: 2000, key: 'supply_electricity_renewable_onshore_land' },
          { id: 264, value: 200, key: 'supply_electricity_renewable_onshore_coast' },
          { id: 265, value: 2000, key: 'supply_electricity_renewable_offshore' }
        ]
      },
      {
        short: "Alles uit eigen energiebronnen halen zoals biomassa, geothermie, zon en wind zodat we zo veel mogelijk onafhankelijk van het buitenland blijven. ",
        long: "Neem instellingen van vraag 1 over plus de instellingen van 2b + 2c en dan tevens deze instellingen",
        inputs: [
          { id: 263, value: 4000, key: 'supply_electricity_renewable_onshore_land' },
          { id: 264, value: 400, key: 'supply_electricity_renewable_onshore_coast' },
          { id: 265, value: 9999, key: 'supply_electricity_renewable_offshore' },
          { id: 47, value: 100, key: 'demand_households_solar_panels' },
          { id: 338, value: 50, key: 'demand_households_heat_pump_(ground)_share' },
          { id: 217, value: 50, key: 'demand_industry_oil_fired_heater_share' },
          { id: 405, value: 100, key: 'demand_buildings_solar_panels' },
          { id: 394, value: 50, key: 'demand_buildings_heat_pump_with_ts_share' },
          { id: 390, value: 50, key: 'demand_buildings_gas_fired_heat_pump_share' }
        ]
      }
    ]
  },
  
  {
    question: "Om het klimaatprobleem het hoofd te bieden is het noodzakelijk dat de uitstoot van het broeikasgas CO2 daalt, door",
    answers: [
      {
        short: "maximale inzet van hernieuwbare bronnen: zon, wind, waterkracht en schone biomassa",
        long: "Check of de gebruiker voor 2b heeft gekozen en waarschuwing geven dat de helft van het aardgas nog steeds wordt gebruikt",
        inputs: [
          { id: 216, value: 66, key: 'demand_industry_gas_fired_heater_share' },
          { id: 217, value: 0, key: 'demand_industry_oil_fired_heater_share' },
          { id: 218, value: 3, key: 'demand_industry_coal_fired_heater_share' },
          { id: 219, value: 0, key: 'demand_industry_biomass_fired_heater_share' },
          { id: 326, value: 31, key: 'demand_industry_combined_heat_power_share' }
        ]
      },
      {
        short: "inzet van CO2 neutrale bronnen, dus hernieuwbare maar ook kernenergie",
        long: "Alle instellingen als bij 3a maar bouw nu ook 3 grote nieuwe kerncentrale en schrap equivalente hoeveelheid wind",
        inputs: [
          { id: 216, value: 66, key: 'demand_industry_gas_fired_heater_share' },
          { id: 217, value: 0, key: 'demand_industry_oil_fired_heater_share' },
          { id: 218, value: 3, key: 'demand_industry_coal_fired_heater_share' },
          { id: 219, value: 0, key: 'demand_industry_biomass_fired_heater_share' },
          { id: 326, value: 31, key: 'demand_industry_combined_heat_power_share' },
          { id: 259, value: 3, key: 'supply_electricity_nuclear_3rd_gen' }
        ]
      },
      {
        short: "de helft van de CO2 vermindering uit hernieuwbare bronnen, de andere helft uit energiebesparing.",
        long: "Neem de instellingen over van 1.  En 2b maar halveer de duurzame energieopties aan de aanbodkant uit 2b en 2c. In aantal. Breng tevens het percentage huizen met zonnepanelen terug tot 50%.",
        inputs: [
          { id: 489, value: 50, key: 'supply_electricity_renewable_natural_gas_share' },
          { id: 488, value: 50, key: 'supply_electricity_renewable_green_gas_total_share' },
          { id: 263, value: 2000, key: 'supply_electricity_renewable_onshore_land' },
          { id: 264, value: 200, key: 'supply_electricity_renewable_onshore_coast' },
          { id: 265, value: 2000, key: 'supply_electricity_renewable_offshore' }
        ]
      },
      {
        short: "Vervangen van kolencentrales door CO2 arme bronnen zoals aardgascentrales ",
        long: "Zou beter zijn om hier informatie te geven over verschil tussen 1 Gas en Kolencentrale in termen van CO2 uitstoot",
        inputs: [
          { id: 250, value: 0, key: 'supply_electricity_pulverized_coal' },
          { id: 251, value: 0, key: 'supply_electricity_pulverized_coal_ccs' },
          { id: 253, value: 0, key: 'supply_electricity_coal_iggc' },
          { id: 254, value: 0, key: 'supply_electricity_coal_igcc_ccs' },
          { id: 255, value: 0, key: 'supply_electricity_coal_oxyfuel_ccs' },
          { id: 256, value: 0, key: 'supply_electricity_conventional' },
          { id: 314, value: 0, key: 'supply_electricity_coal_chp' },
          { id: 256, value: 8, key: 'supply_electricity_conventional' },
          { id: 257, value: 18, key: 'supply_electricity_gas_ccgt' }
        ]
      }
    ]
  }
  
  
]

qct = 0
@questions.each do |q|

  @q = Question.create!(:question => q[:question], :ordering => qct)

  act = 0
  q[:answers].each do |a|
    @a = @q.answers.create!(:answer => a[:short], :description => a[:long], :ordering => act)
    act += 1
    
    a[:inputs].each do |i|
      @a.inputs.create!(:key => i[:key], :value => i[:value])
    end
  end
  qct += 1
end