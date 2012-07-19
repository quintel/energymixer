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
    link_to name.html_safe, params.merge({:sort => field, :order => order})
  end

  # @return [String, nil]
  #   Returns links to the current page in the other supported locales, or nil
  #   if the partition does not support any others.
  #
  def other_locale_links
    return nil unless partition.multi_language?

    others = partition.other_locales(I18n.locale)
    links  = others.map { |lang| link_to h(lang.to_s.upcase), locale: lang }

    links.join("\n").html_safe
  end

end
