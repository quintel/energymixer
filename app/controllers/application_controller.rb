class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :check_touchsceen, :set_api_base_path

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
      session[:locale] = params[:locale] || session[:locale] || I18n.default_locale
      I18n.locale = session[:locale]
    end

    def record_not_found
      flash[:alert] = 'Record not found'
      redirect_to :back
    rescue
      redirect_to root_path
    end
    
    def load_question_set
      @question_set = QuestionSet.find_by_name(APP_NAME) || QuestionSet.first
      @end_year = @question_set.try(:end_year)
    end
    
    def set_api_base_path
      @api_base_path = session[:api_base_path] || APP_CONFIG["api_base_path"]
    end
end
