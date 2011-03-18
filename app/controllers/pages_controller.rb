class PagesController < ApplicationController
  before_filter :find_scenario, :only => :scenario
  skip_before_filter :authenticate_user!

  def home
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
    @questions = Question.ordered.all
    @questions.each do |q|
      @user_scenario.answers.build(:question_id => q.id)
    end
    
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
  
  def save_scenario
    @user_scenario = UserScenario.new(params[:user_scenario])
    if @user_scenario.save
      redirect_to scenario_path(@user_scenario), :notice => 'Scenario saved'
    else
      @questions = Question.ordered.all
      render :home
    end
  end
  
  protected
  
    def find_scenario
      @user_scenario = UserScenario.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, :alert => "Scenario not found"
    end
end
