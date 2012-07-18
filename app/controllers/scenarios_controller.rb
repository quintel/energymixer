class ScenariosController < ApplicationController
  before_filter :find_scenario, :only => [:show, :answers]

  def new
    @scenario = Scenario.new(Scenario.current.attributes)
    @scenario.year = question_set.try(:end_year)

    @questions    = question_set.questions.enabled.ordered rescue []
    @answers      = @questions.map{|q| q.answers}.flatten.uniq

    @questions.each do |q|
      @scenario.answers.build(:question_id => q.id)
    end
  end

  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.year ||= question_set.try(:end_year)
    @scenario.question_set = question_set

    if @scenario.save
      begin
        MixerMailer.thankyou(@scenario).deliver unless APP_CONFIG['standalone'] || @scenario.email.blank?
      rescue
        flash[:alert] = "There was an error sending the email"
      end
      redirect_to scenario_path(@scenario), :notice => 'Scenario saved'
    else
      @questions = question_set.questions.enabled.ordered rescue []
      render :new
    end
  end

  def show
  end

  def answers
    render :layout => false if request.xhr?
  end

  def index
    @scenarios = question_set.scenarios.not_featured.not_average.public.
      by_user(params[:q]).recent_first.page(params[:page])

    @featured_scenarios = question_set.scenarios.featured
    @average_scenarios  = question_set.scenarios.averages

    if params[:selected]
      @selected_scenario = question_set.scenarios.find(params[:selected])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def compare
    ids = params[:ids].take(5) rescue []
    @scenarios = question_set.scenarios.find(ids)
  end

  protected

    def find_scenario
      @scenario = question_set.scenarios.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, :alert => "Scenario not found"
    end
end
