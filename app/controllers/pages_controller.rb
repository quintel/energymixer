class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    @old_results = {
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
    
  end

  def mix
    render :layout => 'naked'
  end
end
