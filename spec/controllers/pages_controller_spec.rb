require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'home'" do
    before do
      2.times { Factory :question }
      2.times { Factory :dashboard_item }
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
  
  describe "POST save_scenario" do
    before do
      @valid_attributes = Factory.attributes_for(:user_scenario)
      question = Factory :question
      @valid_attributes.merge(
        :answers_attributes => {
          :question_id => question.id,
          :answer_id   => question.answers.first.id
        }
      )
    end
    
    it "should save a valid scenario" do
      lambda {
        post :save_scenario, :user_scenario => @valid_attributes
        response.should redirect_to(scenario_path(assigns(:user_scenario)))
      }.should change(UserScenario, :count)
    end
    
    it "should not save a scenario with invalid parameters" do
      lambda {
        post :save_scenario, :user_scenario => @valid_attributes.merge(:name => '')
        response.should render_template(:home)
      }.should_not change(UserScenario, :count)
    end
    
  end
end
