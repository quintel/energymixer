
class PagesController < ApplicationController

  def info
    @popup = Popup.find_by_code(params[:code])
    render :layout => false if request.xhr?
  end

end
