class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => :show
  before_filter :setup_results, :only => :new

  def new
    @user_scenario = UserScenario.new(
      :output_0 => 0,
      :output_1 => 0,
      :output_2 => 0,
      :output_3 => 0,
      :output_4 => 0,
      :output_5 => 0,
      :output_6 => 0,
      :output_7 => 0,
      :output_8 => 0
    )

    Question.ordered.each do |q|
      @user_scenario.answers.build(:question_id => q.id)
    end
  end
  
  def create
    @user_scenario = UserScenario.new(params[:user_scenario])
    if @user_scenario.save
      redirect_to scenario_path(@user_scenario), :notice => 'Scenario saved'
      MixerMailer.thankyou(@user_scenario).deliver
    else
      setup_results
      render :new
    end
  end
  
  def show
  end
  
  def index
    @user_scenarios = UserScenario.recent_first.page(params[:page])
  end
  
  def compare
    ids = params[:ids].take(5) rescue []
    @user_scenarios = UserScenario.find(ids)
  end
  
  protected
  
    def find_scenario
      @user_scenario = UserScenario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, :alert => "Scenario not found"
    end
  
    # TODO: clean up
    # We should move this parameters to a config file or db.
    # I've moved it to a separate method because we need this
    # variables if the scenario save fails and we have to show
    # the page again
    def setup_results
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
    end  
end
