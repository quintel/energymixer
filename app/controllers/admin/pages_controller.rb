class Admin::PagesController < AdminController
  def index
  end
  
  def reset_cache
    Rails.cache.clear
    redirect_to admin_root_path, :notice => "Cache cleared"
  end
end