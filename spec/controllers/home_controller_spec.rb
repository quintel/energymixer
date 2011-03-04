require 'spec_helper'

describe HomeController do
  render_views
  # before do
  #   Factory :question
  # end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
