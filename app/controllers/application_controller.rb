class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale,:check_touchsceen
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected
  
    ##
    # When the et-model is in touchscreen mode the text must be unselectable
    def check_touchsceen
      if params[:touchscreen] == "true"
        session[:touchscreen] = true
      elsif params[:touchscreen] == "reset"      
        session[:touchscreen] = nil
      end
    end
    
    def set_locale
      # if params[:locale] is nil then I18n.default_locale will be used
      I18n.locale = params[:locale]
    end

    def record_not_found
      flash[:alert] = 'Record not found'
      redirect_to :back
    rescue
      redirect_to root_path
    end  
end
