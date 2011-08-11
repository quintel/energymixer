module Api
  class Input < ActiveResource::Base
    self.site = APP_CONFIG["api_base_path"]
  end
end
