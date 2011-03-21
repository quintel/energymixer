module PagesHelper
  def markdown(s)
    BlueCloth.new(s).to_html.html_safe rescue nil
  end
end
