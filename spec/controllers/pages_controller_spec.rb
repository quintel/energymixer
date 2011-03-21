require 'spec_helper'

describe PagesController do
  let(:popup) { Factory :popup }
  
  describe "GET info" do
    it "should show a popup page" do
      get :info, :code => popup.code
      response.should be_success
    end
    
    it "should show a popup page via ajax" do
      xhr :get, :info, :code => popup.code
      response.should be_success
    end
  end
end
