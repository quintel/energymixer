require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'home'" do
    before do
      Factory :question
    end

    it "should be successful" do
      get :home
      response.should be_success
    end
  end
  
  describe "GET scenario" do
    it "should redirect invalid requests" do
      get :scenario, :id => 'foo'
      response.should be_redirect
    end
    
    it "should show an existing scenario" do
      @user_scenario = Factory :user_scenario
      get :scenario, :id => @user_scenario.id
      response.should be_success
      assigns(:user_scenario).should == @user_scenario
    end    
  end
end
