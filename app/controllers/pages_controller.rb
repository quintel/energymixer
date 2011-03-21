class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def info
    @popup = Popup.find_by_code(params[:code])
  end
end
