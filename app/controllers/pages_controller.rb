class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    # Be careful with this variable! The CSS currently uses the gquery value to
    # style the graph
    @results = {    
      coal: {
       gquery: "costs_share_of_coal",
       unit: "Mln. Euro",
       label: "Coal"
      },
      natural_gas: {
       gquery: "costs_share_of_gas",
       unit: "Mln. Euro",
       label: "Gas"
      }, 
      total_cost_of_primary_oil: {
       gquery: "costs_share_of_oil",
       unit: "Mln. Euro",
       label: "Oil"
      },
      total_cost_of_primary_nuclear: {
       gquery: "costs_share_of_uranium",
       unit: "Mln. Euro",
       label: "Uranium"
      }, 
      renewable: {
       gquery: "costs_share_of_sustainable",
       unit: "Mln. Euro",
       label: "Sustainable"
      }
    }
    
    # This hash keys will be used to create the dashboard items. Mixer.js uses this keys too
    # to perform queries.
    @dashboard_items = {
      co2_emission: "CO2 Emissions",
      share_of_renewable_energy: "Share of renewable energy",
      area_footprint_per_nl: "Area Footprint per NL",
      energy_dependence: "Energy Dependence"
    }

  end
end
