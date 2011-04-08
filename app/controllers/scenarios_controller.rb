class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => [:show, :answers]

  def new
    @scenario = Scenario.current.clone
    @scenario.year = 2025

    Question.ordered.each do |q|
      @scenario.answers.build(:question_id => q.id)
    end
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    if @scenario.save
      # We're using this session variable to compare the current scenario
      session[:scenario_id] = @scenario.id
      begin
        MixerMailer.thankyou(@scenario).deliver
      rescue
        flash[:alert] = "There was an error sending the email"
      end
      redirect_to scenario_path(@scenario), :notice => 'Scenario saved'
    else
      render :new
    end
  end
  
  def show
  end
  
  def answers
    render :layout => false if request.xhr?
  end
  
  def index
    @selected_scenario  = Scenario.find(params[:selected]) if params[:selected]
    
    scope      = Scenario.user_created.recent_first
    scope      = scope.excluding(session[:scenario_id]) if session[:scenario_id]
    scope      = scope.by_user(params[:q]) unless params[:q].blank?
    @scenarios = scope.page(params[:page])
    @featured_scenarios = Scenario.featured.all
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def compare
    ids = params[:ids].take(4) rescue []
    @scenarios = Scenario.find(ids)
  end
  
  protected
  
    def find_scenario
      @scenario = Scenario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, :alert => "Scenario not found"
    end
end
