class PagesController < ApplicationController

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
  end

  def mix
    render :layout => 'naked'
  end
end
