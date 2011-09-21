class PagesController < ApplicationController
  before_filter :load_question_set
  
  def home
  end
  
  def info
    @popup = Popup.find_by_code(params[:code])
    render :layout => false if request.xhr?
  end
end
