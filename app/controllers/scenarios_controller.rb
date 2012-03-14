class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => [:show, :answers]
  before_filter :load_question_set
  
  def new
    @scenario = Scenario.current.clone
    @scenario.year = @question_set.try(:end_year)

    @questions    = @question_set.questions.enabled.ordered rescue []
    @answers      = @questions.map{|q| q.answers}.flatten.uniq
    
    @questions.each do |q|
      @scenario.answers.build(:question_id => q.id)
    end
  end
  
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.year ||= @question_set.try(:end_year)
    if @scenario.save
      begin
        MixerMailer.thankyou(@scenario).deliver unless APP_CONFIG['standalone'] || @scenario.email.blank?
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
    @scenarios = Scenario.not_featured.not_average.public.by_user(params[:q]).recent_first.page(params[:page])
    @featured_scenarios = Scenario.featured
    @average_scenarios  = Scenario.averages
    
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
