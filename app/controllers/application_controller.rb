class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected
  
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
