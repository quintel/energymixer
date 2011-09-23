module ApplicationHelper
  def controller_name
    controller.controller_name
  end

  def page_title(t)
    content_for(:page_title) { t }
  end
end
