module Api
  class Input < ActiveResource::Base
    self.site = APP_CONFIG["api_url"] + '/api/v3'
  end
end
