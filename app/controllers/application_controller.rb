class ApplicationController < ActionController::Base

  # NOTE uncomment this when you're ready for prime time
  # before_filter :authenticate_user!

  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

protected

  def record_not_found
    flash[:alert] = 'Record not found'
    redirect_to :back
  rescue
    redirect_to root_path
  end

  # Overridden to send admins to the questions index automatically
  def after_sign_in_path_for(resource)
    questions_path
  end

end
