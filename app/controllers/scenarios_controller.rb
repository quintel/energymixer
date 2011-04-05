class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => :show
  before_filter :setup_results, :only => :new

  def new
    @scenario = Scenario.new(
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
      @scenario.answers.build(:question_id => q.id)
    end
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    if @scenario.save
      session[:scenario_id] = @scenario.etm_scenario_id
      begin
        MixerMailer.thankyou(@scenario).deliver
      rescue
        flash[:alert] = "There was an error sending the email"
      end
      redirect_to scenario_path(@scenario), :notice => 'Scenario saved'
    else
      setup_results
      render :new
    end
  end
  
  def show
    @scenario_id = session.delete(:scenario_id)
  end
  
  def index
    @selected_scenario  = Scenario.find(params[:selected]) if params[:selected]
    
    scope               = Scenario.user_created.recent_first
    scope               = scope.by_user(params[:q]) unless params[:q].blank?
    @scenarios          = scope.page(params[:page])
    @featured_scenarios = Scenario.featured.all
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def compare
    ids = params[:ids].take(5) rescue []
    @scenarios = Scenario.find(ids)
  end
  
  protected
  
    def find_scenario
      @scenario = Scenario.find(params[:id])
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
         label: I18n.t('coal'),
         css_class: "coal"
        },
        gas: {
         gquery: "costs_share_of_gas",
         label: I18n.t('gas'),
         css_class: "gas"
        }, 
        oil: {
         gquery: "costs_share_of_oil",
         label: I18n.t('oil'),
         css_class: "oil"
        },
        nuclear: {
         gquery: "costs_share_of_uranium",
         label: I18n.t('nuclear'),
         css_class: "nuclear"

        }, 
        renewable: {
         gquery: "costs_share_of_sustainable",
         label: I18n.t('sustainable'),
         css_class: "renewable"       
        }
      }      
    end
end
