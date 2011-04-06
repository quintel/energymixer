class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => [:show, :answers]

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
end
