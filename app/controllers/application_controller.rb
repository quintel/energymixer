class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    # Overridden to send admins to the questions index automatically
    def after_sign_in_path_for(resource)
      questions_path
    end
end
