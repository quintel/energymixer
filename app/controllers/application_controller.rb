class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_partition!, :require_question_set!,
    :set_locale, :check_touchsceen, :append_theme_path

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

  # Enables support for theming by placing custom view files into the
  # app/views/{partition.name} directory.
  def append_theme_path
    prepend_view_path(Rails.root.join('app', 'views', partition.name))
    @ctrl_view_paths = lookup_context.view_paths.paths
  end

  def record_not_found
    flash[:alert] = 'Record not found'
    redirect_to :back
  rescue
    redirect_to root_path
  end

  def default_locale
    partition.default_locale || I18n.default_locale
  end

  # @return [QuestionSet]
  #   Returns the QuestionSet for the request. The question set is determined
  #   by the current partition.
  #
  # @raise [RuntimeError]
  #   Raised if no matching QuestionSet is present in the database.
  #
  def question_set
    @question_set ||= partition.question_set
  rescue ActiveRecord::RecordNotFound
    # Do not allow the RNF to be raised; the default handler will redirect to
    # the root page. No question set will be found again, and the client will
    # begin an infinite redirect loop.
    raise "No question set matches partition #{ partition.name.inspect }"
  end

  # Alias for filters.
  alias_method :require_question_set!, :question_set

  helper_method :question_set

  # @return [Partition]
  #   Returns the Partition with settings for the current subdomain.
  #
  # @raise [RuntimeError]
  #   Raises if the named partition does not exist, or if no subdomain is
  #   present.
  #
  def partition
    @partition ||= Partition.named(request.subdomains.join('.'))
  end

  # Alias for filters.
  alias_method :require_partition!, :partition

  helper_method :partition
end
