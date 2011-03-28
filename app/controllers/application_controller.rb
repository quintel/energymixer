class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected
  
    def record_not_found
      flash[:alert] = 'Record not found'
      redirect_to :back
    rescue
      redirect_to root_path
    end  
end
