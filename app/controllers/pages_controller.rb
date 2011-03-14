class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    @results = {
      mix: {
        coal: {
          gquery: "total_cost_of_primary_coal",
          unit: "Mln. Euro"
        },
        natural_gas: {
          gquery: "total_cost_of_primary_natural_gas",
          unit: "Mln. Euro"
        }, 
        total_cost_of_primary_oil: {
          gquery: "total_cost_of_primary_oil",
          unit: "Mln. Euro"
        },
        total_cost_of_primary_nuclear: {
          gquery: "total_cost_of_primary_nuclear",
          unit: "Mln. Euro"
        }, 
        renewable: {
          gquery: "total_cost_of_primary_renewable",
          unit: "Mln. Euro"
        }
      },
      dashboard: {
        coal: "total_cost_of_primary_coal", 
        natural_gas: "total_cost_of_primary_natural_gas", 
        total_cost_of_primary_oil: "total_cost_of_primary_oil", 
        total_cost_of_primary_nuclear: "total_cost_of_primary_nuclear", 
        renewable: "total_cost_of_primary_renewable"
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
