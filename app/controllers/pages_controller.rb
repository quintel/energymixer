class PagesController < ApplicationController
  before_filter :find_scenario, :only => :scenario
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
    
    @dashboard_items = DashboardItem.ordered.all    
  end
  
  def scenario
  end
  
  protected
  
    def find_scenario
      @user_scenario = UserScenario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, :alert => "Scenario not found"
    end
end
