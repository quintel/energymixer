class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :check_touchsceen

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
    session[:locale] = params[:locale] || session[:locale] || default_locale
    session[:locale] = default_locale unless [:nl, :de, :en].include?(session[:locale].to_sym)
    I18n.locale = session[:locale]
  end

  def record_not_found
    flash[:alert] = 'Record not found'
    redirect_to :back
  rescue
    redirect_to root_path
  end

  def load_question_set
    @question_set = partition.question_set
    @end_year     = @question_set.try(:end_year)
  end

  def default_locale
    partition.default_locale || I18n.default_locale
  end

  # @return [Partition]
  #   Returns the Partition with settings for the current subdomain.
  #
  # @raise [RuntimeError]
  #   Raises if the named partition does not exist, or if no subdomain is
  #   present.
  #
  def partition
    subdomain = request.subdomains.join('.')

    unless PARTITIONS.has_key?(subdomain)
      raise "No such partition: #{subdomain.inspect}"
    end

    @partition ||= Partition.named(subdomain)
  end

  helper_method :partition
end
