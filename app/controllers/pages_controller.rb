class PagesController < ApplicationController
  before_filter :load_question_set

  def home
    @intro_data = ApiClient.new.intro_page_data rescue {}
  end

  def info
    @popup = Popup.find_by_code(params[:code])
    render :layout => false if request.xhr?
  end

  def stats
    order = ['title', 'name', 'output_5', 'output_6', 'output_8', 'output_12'].include?(params[:sort]) ? params[:sort] : 'id'
    direction = ['asc', 'desc'].include?(params[:order]) ? params[:order] : 'asc'
    @scenarios = Scenario.not_featured.not_average.public.order("#{order} #{direction}").page(params[:page]).per(30)
  end

  def full_stats
  end

  def analysis
    @scenarios = Scenario.find(params[:scenario_ids])
  end
end
