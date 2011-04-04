class PagesController < ApplicationController
  def home
    # TODO: DRY, this same code appears on ScenarioController
    @current_scenario = Scenario.new(
      :output_0 => 3948583406.649,
      :output_1 => 19010942227.973732,
      :output_2 => 14894948012.582876,
      :output_3 => 536620590.0778774,
      :output_4 => 2385593709.4479237
      :year     => 2011
    )    
  end
  
  def info
    @popup = Popup.find_by_code(params[:code])
    render :layout => false if request.xhr?
  end
end
