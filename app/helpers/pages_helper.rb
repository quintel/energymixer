module PagesHelper
  def markdown(s)
    BlueCloth.new(s).to_html.html_safe rescue nil
  end
  
  def embed_video(popup)
    return unless url = popup.video
    if url =~ /youtube/ && !APP_CONFIG[:standalone]
      %(<object width="640" height="385"><param name="movie" value="#{url}"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="#{url}" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="300"></embed></object>).html_safe
    end
  end
end
