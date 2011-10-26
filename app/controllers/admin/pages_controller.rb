class Admin::PagesController < AdminController
  skip_before_filter :set_api_base_path, :only => :index
  
  def index
    session[:api_base_path] = params[:api_base_path] unless params[:api_base_path].blank?
    set_api_base_path
  end
  
  def reset_cache
    Rails.cache.clear
    redirect_to admin_root_path, :notice => "Cache cleared"
  end
end