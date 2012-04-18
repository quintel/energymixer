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
  end
end
