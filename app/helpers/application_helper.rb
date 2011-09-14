module ApplicationHelper
  def controller_name
    controller.controller_name
  end

  # DEBT: replace t(APP_CONFIG['app_name']) with app_name
  #       it is used throughout the application
  def app_name
    t(APP_CONFIG['app_name'])
  end
  
  def page_title(t)
    content_for(:page_title) { t }
  end
end
