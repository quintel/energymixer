class AdminController < ApplicationController
  # before_filter :authenticate_user!
  
  layout "admin"

  # Overridden to send admins to the questions index automatically
  def after_sign_in_path_for(resource)
    admin_questions_path
  end
end
