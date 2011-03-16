class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    # Be careful with this variable!
    @results = {    
      coal: {
       gquery: "costs_share_of_coal",
       unit: "Mln. Euro",
       label: "Coal",
       css_class: "coal"
      },
      gas: {
       gquery: "costs_share_of_gas",
       unit: "Mln. Euro",
       label: "Gas",
       css_class: "gas"
      }, 
      oil: {
       gquery: "costs_share_of_oil",
       unit: "Mln. Euro",
       label: "Oil",
       css_class: "oil"
      },
      nuclear: {
       gquery: "costs_share_of_uranium",
       unit: "Mln. Euro",
       label: "Uranium",
       css_class: "nuclear"
       
      }, 
      renewable: {
       gquery: "costs_share_of_sustainable",
       unit: "Mln. Euro",
       label: "Sustainable",
       css_class: "renewable"       
      }
    }
    
    # This hash keys will be used to create the dashboard items. Mixer.js uses this keys too
    # to perform queries.
    # A word about steps: a something like this [0.0, 0.25, 0.5, 0.75]
    # is translated in the followin categories:
    # * [-inf, 0.0]   css_suffix: _0 # boundary check
    # * [0.0, 0.25]   css_suffix: _0
    # * (0.25), 0.5]   css_suffix: _1
    # * (0.5), 0.75]   css_suffix: _2
    # * (0.75), +inf]  css_suffix: _3
    # The CSS file should define classes named as the gquery + the suffix
    @dashboard_items = [
      { 
        gquery: "co2_emission_final_demand_to_1990_in_percent",
        label: "CO2 Emissions",
        steps:  [0.0, 0.25, 0.5, 0.75]
      },
      { 
        gquery: "share_of_renewable_energy",
        label:  "Share of renewable energy",
        steps:  [0.0, 0.25, 0.5, 0.75]
      },
      { 
        gquery: "area_footprint_per_nl",
        label:  "Area Footprint per NL",
        steps:  [0.0, 0.25, 0.5, 0.75]
      },
      { 
        gquery: "energy_dependence",
        label:  "Energy Dependence",
        steps:  [0.0, 0.25, 0.5, 0.75]
      }
    ]
  end

end
