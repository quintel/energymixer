require 'active_record/fixtures'

Question.destroy_all

@questions = [
  {
    question: "Wat is naar uw idee de prijs van fossiele brandstof(olie, gas en kolen) in 2025?",
    information: "De prijsontwikkeling van energie is van veel factoren afhankelijk. Zo kan de prijs gaan stijgen als gevolg van vraagtoename (door groei wereldbevolking en toename welvaart), en doordat de winning van brandstof moeilijker en duurder wordt (olie uit dieper gelegen velden etc). Factoren die de prijs kunnen drukken zijn toenemende besparingen en het goedkoper worden van de winning van hernieuwbare energie.",
    answers: [
      {
        short: "Even duur",
        long: "Het blijft even duur",
        inputs: [
          { id: 58, value: 0, key: 'costs_combustion_gas' },
          { id: 11, value: 0, key: 'costs_combustion_oil' },
          { id: 57, value: 0, key: 'costs_combustion_coal' },
          { id: 59, value: 0, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Het wordt duurder",
        long: "Fosiele brandstoffen worden 25% duurder",
        inputs: [
          { id: 58, value: 25, key: 'costs_combustion_gas' },
          { id: 11, value: 25, key: 'costs_combustion_oil' },
          { id: 57, value: 25, key: 'costs_combustion_coal' },
          { id: 59, value: 25, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Het wordt veel duurder",
        long: "Fosiele brandstoffen worden 100% duurder",
        inputs: [
          { id: 58, value: 100, key: 'costs_combustion_gas' },
          { id: 11, value: 100, key: 'costs_combustion_oil' },
          { id: 57, value: 100, key: 'costs_combustion_coal' },
          { id: 59, value: 100, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Het wordt goedkoper",
        long: "Fosiele brandstoffen worden 25% goedkoper",
        inputs: [
          { id: 58, value: -25, key: 'costs_combustion_gas' },
          { id: 11, value: -25, key: 'costs_combustion_oil' },
          { id: 57, value: -25, key: 'costs_combustion_coal' },
          { id: 59, value: -25, key: 'costs_combustion_biomass' }
        ]
      },
      {
        short: "Het wordt veel goedkoper",
        long: "Fosiele brandstoffen worden 50% goedkoper",
        inputs: [
          { id: 58, value: -50, key: 'costs_combustion_gas' },
          { id: 11, value: -50, key: 'costs_combustion_oil' },
          { id: 57, value: -50, key: 'costs_combustion_coal' },
          { id: 59, value: -50, key: 'costs_combustion_biomass' }
        ]
      }
    ]
  },
  
  {
    question: "Wat vindt u dat we moeten doen om voldoende energie beschikbaar te hebben in Nederland in 2025, ervan uitgaande dat we wel een deel blijven exporteren?",
    information: "Nederland is een aardgasproducerend land. Op dit moment gebruiken we ongeveer de helft zelf en de helft exporteren we. Omdat de velden leger worden, <a href='#'>neemt de productie af</a>, naar verwachting met 50% tot 2025.",
    answers: [
      {
        short: "Aardgas importeren, met name uit Rusland",
        long: "Er verandert verder niets bij deze keuze",
        inputs: []
      },
      {
        short: "Dit opvangen voor de helft met  aardgas import en de andere helft met besparingen",
        long: "",
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
        long: "[NOTE] Dezelfde instellingen van 1b maar tevens de volgende maatregelen aan de aanbodkant (350PJ hernieuwbaar inzetten verdeeld over biomassa zon en wind",
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
        short: "Het tekort aan aardgas geheel uit andere, eigen energiebronnen halen zoals biomassa, geothermie, zon en wind om afhankelijkheid van het buitenland zo klein mogelijk te houden",
        long: "[NOTE] Neem instellingen van vraag 1 over plus de instellingen van 2b + 2c en dan tevens deze instellingen",
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
    question: "Wat vindt u dat we in Nederland moeten doen om de uitstoot van CO2 broeikasgas te laten dalen?",
    information: "Bij de verbranding van fossiele brandstoffen (olie, kolen en gas) komt CO2 vrij. De concentratie hiervan in de atmosfeer loopt op, evenals de temperatuur op aarde. De veronderstelling is dat de CO2-uitstoot een negatieve invloed heeft op de opwarming van de aarde (broeikaseffect).",
    answers: [
      {
        short: "Niets. Ik betwijfel het verband tussen CO2-uitstoot en de opwarming van de aarde. Andere landen gaan toch door met de CO2 uitstoot, een actieve houding van Nederland zal weinig effect hebben.",
        long: "[NOTE] Er gebeurt niets.",
        inputs: []
      },
      {
        short: "Maximale inzet van hernieuwbare bronnen: zon, wind, waterkracht en schone biomassa",
        long: "[NOTE] Check of de gebruiker voor 2b heeft gekozen en waarschuwing geven dat de helft van het aardgas nog steeds wordt gebruikt",
        inputs: [
          { id: 216, value: 66, key: 'demand_industry_gas_fired_heater_share' },
          { id: 217, value: 0, key: 'demand_industry_oil_fired_heater_share' },
          { id: 218, value: 3, key: 'demand_industry_coal_fired_heater_share' },
          { id: 219, value: 0, key: 'demand_industry_biomass_fired_heater_share' },
          { id: 326, value: 31, key: 'demand_industry_combined_heat_power_share' }
        ]
      },
      {
        short: "Maximale inzet van CO2-neutrale bronnen, dus hernieuwbare maar ook kernenergie",
        long: "[NOTE] Alle instellingen als bij 3a maar bouw nu ook 3 grote nieuwe kerncentrale en schrap equivalente hoeveelheid wind",
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
        short: "Alleen kolencentrales vervangen door CO2 arme bronnen zoals aardgascentrales",
        long: "[NOTE] Neem de instellingen over van 1.  En 2b maar halveer de duurzame energieopties aan de aanbodkant uit 2b en 2c. In aantal. Breng tevens het percentage huizen met zonnepanelen terug tot 50%.",
        inputs: []
      },
      {
        short: "Vervangen van kolencentrales door CO2 arme bronnen zoals aardgascentrales",
        long: "[NOTE] Zou goed zijn om hier informatie te geven over verschil tussen 1 Gas en Kolencentrale in termen van CO2 uitstoot",
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
      },
      {
        short: "Alleen opvang en opslag van CO2 uit grote emissiebronnen (bv kolencentrales en olieraffinaderijen)",
        long: "[NOTE] Olierafinaderijen zitten niet in het model. Er moet nog bepaald worden HOEVEEL suppl",
        inputs: [
          { id: 250, value: 0, key: 'supply_electricity_pulverized_coal' },
          { id: 251, value: 2, key: 'supply_electricity_pulverized_coal_ccs' },
          { id: 253, value: 0, key: 'supply_electricity_coal_iggc' },
          { id: 254, value: 2, key: 'supply_electricity_coal_igcc_ccs' },
          { id: 255, value: 2, key: 'supply_electricity_coal_oxyfuel_ccs' },
          { id: 256, value: 0, key: 'supply_electricity_conventional' }
        ]
      }
    ]
  },
  {
    question: "Welke 'brandstoffen' zullen we in 2025 naar uw verwachting gebruiken voor het Nederlandse wegverkeer?",
    information: "18% van onze totale energievraag komt van het wegverkeer (auto's, bussen en vrachtwagens). Op dit moment rijden vrijwel alle vrachtwagens en bussen op diesel (voor 3% bijgemengd met biodiesel), van de auto's rijdt nu 47% op diesel, 48% op benzine en 5% op LPG. Het aandeel elektrische auto's is op dit moment nog verwaarloosbaar klein.",
    answers: [
      {
        short: "Hoofdzakelijk nog steeds benzine, diesel.",
        long: "De brandstofmix is in de toekomst hetzelfde als nu.",
        inputs: []
      },
      {
        short: "Benzine en diesel met een kwart biobrandstof bijgemengd",
        long: "",
        inputs: [
          { id: 293, value: 25, key: 'transport_biodiesel_share' },
          { id: 295, value: 25, key: 'transport_bio_ethanol_share' }
        ]
      },
      {
        short: "De helft van de auto's rijdt nog op benzine/diesel/biobrandstof, de andere helft op elektriciteit, waarbij de elektriciteit voornamelijk opgewekt is met fossiele brandstof.",
        long: "",
        inputs: [
          { id: 146, value: 50, key: 'transport_cars_electric_share' }
        ]
      },
      {
        short: "De helft van de auto's rijdt nog op benzine/diesel/biobrandstof, de andere helft op elektriciteit, waarbij de elektriciteit geheel uit hernieuwbare bronnen komt.",
        long: "[NOTE] herniewbare bronnen moeten nog worden aangepast!",
        inputs: [
          { id: 146, value: 50, key: 'transport_cars_electric_share' }
        ]
      }
    ]
  },
  {
    question: "Wat verwacht u dat er in 2025 is veranderd in de energiebehoefte van huizen en gebouwen?",
    information: "Huizen en gebouwen gebruiken op dit moment 28% van alle energie in Nederland, waarbij ruim 72% op gaat aan verwarming. Die verwarming op haar beurt wordt bijna geheel door aardgas geleverd.",
    answers: [
      {
        short: "De energiebehoefte blijft ongeveer gelijk. De huizen worden wel steeds iets energiezuiniger maar de mensen gaan ook steeds luxer leven.",
        long: "Er verandert hierdoor dus niets uit de uitkomsten.",
        inputs: [
        ]
      },
      {
        short: "Nieuwe gebouwen zijn zo goed geisoleerd dat ze met de helft van het aardgas toe kunnen",
        long: "",
        inputs: [
          { id: 337, value: 6, key: 'households_insulation_level_new_houses' },
          { id: 381, value: 2, key: 'buildings_insulation_level_schools' }, # 3 = max
          { id: 382, value: 3, key: 'buildings_insulation_level_offices' } # 4 = max
        ]
      },
      {
        short: "Nieuwe gebouwen hebben geen aardgas meer nodig voor verwarming ",
        long: "(o.a. door toepassing van  hoogwaardige isolatie, gunstige zonligging en gebruik van nieuwe verwarmingstechnieken als warmtepompen)",
        inputs: [
          { id: 337, value: 6, key: 'households_insulation_level_new_houses' },
          { id: 381, value: 3, key: 'buildings_insulation_level_schools' },
          { id: 382, value: 4, key: 'buildings_insulation_level_offices' },
          { id: 338, value: 100, key: 'households_heating_heat_pump_ground_share' }, # This is the electric heat pump that we want to use
          { id: 48,  value: 0, key: 'households_heating_solar_thermal_panels_share'},
          { id: 51,  value: 0, key: 'households_heating_micro_chp_share'},
          { id: 52,  value: 0, key: 'households_heating_electric_heater_share'},
          { id: 242, value: 0, key: 'households_heating_small_gas_chp_share'},
          { id: 248, value: 0, key: 'households_heating_oil_fired_heater_share'},
          { id: 317, value: 0, key: 'households_heating_gas_fired_heat_pump_share'},
          { id: 333, value: 0, key: 'households_hot_water_gas_combi_heater_share'},
          { id: 338, value: 0, key: 'households_heating_heat_pump_ground_share'},
          { id: 339, value: 0, key: 'households_heating_heat_pump_add_on_share'},
          { id: 340, value: 0, key: 'households_heating_pellet_stove_share'},
          { id: 341, value: 0, key: 'households_heating_heat_network_share'},
          { id: 343, value: 0, key: 'households_heating_biomass_chp_share'},
          { id: 344, value: 0, key: 'households_heating_geothermal_share'},
          { id: 375, value: 0, key: 'households_heating_heat_pump_with_ts_share'},
          { id: 411, value: 0, key: 'households_heating_coal_fired_heater_share'},
          { id: 441, value: 0, key: 'households_heating_gas_fired_heater_share)'}
        ]                           
      },
      {
        short: "Ook de oudere gebouwen zijn goed ge&#239;soleerd en kunnen met de helft minder aardgas toe.",
        long: "",
        inputs: [
          { id: 336, value: 3, key: 'households_insulation_level_old_houses' },
          { id: 337, value: 6, key: 'households_insulation_level_new_houses' },
          { id: 381, value: 2, key: 'buildings_insulation_level_schools' }, # 3 = max
          { id: 382, value: 3, key: 'buildings_insulation_level_offices' } # 4 = max
        ]
      }
    ]
  },
  {
    question: "Naar uw verwachting zal de industrie richting 2025:",
    information: "Nederland is een industrierijk land. De energiebehoefte van de industrie beslaat 47% van de totale vraag (in vergelijk: in Engeland is dit slechts 26%).",
    answers: [
      {
        short: "Snel groeien door een snel groeiende wereldeconomie en de behoefte aan energie stijgt navenant",
        long: "De energievraag van de industrie groeit ieder jaar met 4%",
        inputs: [
          { id: 213, value: 4, key: 'industry_electricity_demand' }, #in interface, max is 5%
          { id: 214, value: 4, key: 'industry_heat_demand' }, #in interface, max is 5%
          { id: 205, value: 4, key: 'industry_non_energetic_oil_demand' }, #in interface, max is 5%
          { id: 202, value: 4, key: 'industry_non_energetic_other_demand' }  #in interface, max is 5%
        ]
      },
      {
        short: "Snel groeien, maar de energiebehoefte stijgt minder snel door groeiende effici&euml;ntie in energiegebruik",
        long: "De energievraag van de industrie groeit ieder jaar met 4%, effici&euml;ntie verbeterd met 2% per jaar.",
        inputs: [
          { id: 213, value: 4, key: 'industry_electricity_demand' },
          { id: 214, value: 4, key: 'industry_heat_demand' },
          { id: 205, value: 4, key: 'industry_non_energetic_oil_demand' },
          { id: 202, value: 4, key: 'industry_non_energetic_other_demand' },
          { id: 169, value: 2, key: 'industry_efficiency_electricity' },
          { id: 170, value: 2, key: 'industry_heat_from_fuels' }
        ]
      },
      {
        short: "Langzaam groeien, de energiebehoefte stijgt ook maar licht",
        long: "De energievraag van de industrie stijgt met 2% per jaar.",
        inputs: [
          { id: 213, value: 2, key: 'industry_electricity_demand' },
          { id: 214, value: 2, key: 'industry_heat_demand' },
          { id: 205, value: 2, key: 'industry_non_energetic_oil_demand' },
          { id: 202, value: 2, key: 'industry_non_energetic_other_demand' }
        ]
      },
      {
        short: "Langzaam groeien en door verregaande effici&euml;ntie stijgt de energiebehoefte niet of daalt zelfs licht",
        long: "De energievraag van de industrie groeit ieder jaar met 1%, efficientie verbeterd met 2% per jaar.",
        inputs: [
          { id: 213, value: 1, key: 'industry_electricity_demand' },
          { id: 214, value: 1, key: 'industry_heat_demand' },
          { id: 205, value: 1, key: 'industry_non_energetic_oil_demand' },
          { id: 202, value: 1, key: 'industry_non_energetic_other_demand' },
          { id: 169, value: 2, key: 'industry_efficiency_electricity' },
          { id: 170, value: 2, key: 'industry_heat_from_fuels' }
        ]
      },
      {
        short: "Langzaam krimpen (produktie is hier te duur), energiebehoefte neemt navenant af.",
        long: "De energievraag van de industrie daalt met 2% per jaar.",
        inputs: [
          { id: 213, value: -2, key: 'industry_electricity_demand' },
          { id: 214, value: -2, key: 'industry_heat_demand' },
          { id: 205, value: -2, key: 'industry_non_energetic_oil_demand' },
          { id: 202, value: -2, key: 'industry_non_energetic_other_demand' }
        ]
      }
    ]
  },
  {
    question: "Waar komt de benodigde energie voor tuinbouw vandaan in 2025?",
    information: "Landbouw in Nederland is verantwoordelijk voor 6% van de totale energievraag. Maar liefst 80% daarvan komt uit de tuinbouw met haar kassen, de rest uit akkerbouw en veeteelt. Op dit moment komt vrijwel alle benodigde energie uit aardgas.",
    answers: [
      {
        short: "Onveranderlijk uit fossiele energiebronnen.",
        long: "",
        inputs: [
        ]
      },
      {
        short: "Voor een kwart uit zelf opgewekte energie uit biomassa en de rest uit fossiele energie.",
        long: "",
        inputs: [
          { id: 246, value: 40, key: 'agriculture_heating_gas_fired_heater_share' },
          { id: 223, value: 5, key: 'agriculture_heating_oil_fired_heater_share' },
          { id: 225, value: 30, key: 'agriculture_heating_biomass_fired_heater_share'},
          { id: 227, value: 0, key: 'agriculture_heating_heat_pump_with_ts_share'},
          { id: 228, value: 0, key: 'agriculture_heating_geothermal_share'},
          { id: 327, value: 25, key: 'agriculture_heating_combined_heat_power_share'}
        ]
      },
      {
        short: "Voor een kwart uit zelf opgewekte energie met biomassa, een kwart met geothermische energie en de helft met fossiele energie.",
        long: "",
        inputs: [
          { id: 246, value: 15, key: 'agriculture_heating_gas_fired_heater_share' },
          { id: 223, value: 0, key: 'agriculture_heating_oil_fired_heater_share' },
          { id: 225, value: 30, key: 'agriculture_heating_biomass_fired_heater_share'},
          { id: 227, value: 0, key: 'agriculture_heating_heat_pump_with_ts_share'},
          { id: 228, value: 30, key: 'agriculture_heating_geothermal_share' },
          { id: 327, value: 25, key: 'agriculture_heating_combined_heat_power_share'}          
        ]
      },
      {
        short: "Voor 100% uit eigen biomassa plus ge&#239;mporteerde biomassa en geothermie ",
        long: "",
        inputs: [
          { id: 246, value: 0, key: 'agriculture_heating_gas_fired_heater_share' },
          { id: 223, value: 0, key: 'agriculture_heating_oil_fired_heater_share' },
          { id: 225, value: 100, key: 'agriculture_heating_biomass_fired_heater_share'},
          { id: 227, value: 0, key: 'agriculture_heating_heat_pump_with_ts_share'},
          { id: 228, value: 0, key: 'agriculture_heating_geothermal_share' },
          { id: 327, value: 0, key: 'agriculture_heating_combined_heat_power_share'}          
        ]
      }
    ]
  }  
]

qct = 0
@questions.each do |q|

  @q = Question.create!(:question => q[:question], :ordering => qct, :information => q[:information])

  act = 0
  q[:answers].each do |a|
    @a = @q.answers.create!(:answer => a[:short], :description => a[:long], :ordering => act)
    act += 1
    
    a[:inputs].each do |i|
      @a.inputs.create!(:key => i[:key], :value => i[:value], :slider_id => i[:id])
    end
  end
  qct += 1
end
