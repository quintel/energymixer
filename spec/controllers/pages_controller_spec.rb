require 'spec_helper'

describe PagesController do
  render_views

  before do
    Factory :question
  end
  
  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
  end

end
