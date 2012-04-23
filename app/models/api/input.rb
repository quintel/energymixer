module Api
  class Input < ActiveResource::Base
    self.site = APP_CONFIG["api_url"]
    self.format = :xml
  end
end
