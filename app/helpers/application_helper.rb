module ApplicationHelper
  def controller_name
    controller.controller_name
  end

  def page_title(t)
    content_for(:page_title) { t }
  end

  def ipad?
    request.env['HTTP_USER_AGENT'].downcase.index('ipad')
  rescue
    false
  end

  def sortable_header(name, field = nil)
    field ||= name
    order = params[:order] == 'asc' ? 'desc' : 'asc'
    link_to name, {:sort => field, :order => order}
  end
end
