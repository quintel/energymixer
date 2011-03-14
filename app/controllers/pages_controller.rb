class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    @results = {    
      mix: {
        coal: {
          gquery: "costs_share_of_coal",
          unit: "Mln. Euro"
        },
        natural_gas: {
          gquery: "costs_share_of_gas",
          unit: "Mln. Euro"
        }, 
        total_cost_of_primary_oil: {
          gquery: "costs_share_of_oil",
          unit: "Mln. Euro"
        },
        total_cost_of_primary_nuclear: {
          gquery: "costs_share_of_uranium",
          unit: "Mln. Euro"
        }, 
        renewable: {
          gquery: "costs_share_of_sustainable",
          unit: "Mln. Euro"
        }
      },
      dashboard: {
        coal: "costs_share_of_coal", 
        natural_gas: "costs_share_of_gas", 
        total_cost_of_primary_oil: "costs_share_of_coal", 
        total_cost_of_primary_nuclear: "costs_share_of_uranium", 
        renewable: "costs_share_of_sustainable"
      }
    }
    
    @boxes = {
      CO2: "co2_emission",
      sustainability: "share_of_renewable_energy",
      bio_footprint: "area_footprint_per_nl",
      net_energy_import: "energy_dependence"
    }
  end

end
