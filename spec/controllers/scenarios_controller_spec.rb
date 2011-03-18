require 'spec_helper'

describe ScenariosController do
  render_views

  describe "GET index" do
    before do
      @scenarios = Array.new(3).map { Factory :user_scenario }
    end
    
    it "should show a list of existing scenarios" do
      get :index
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    before do
      2.times { Factory :question }
      2.times { Factory :dashboard_item }
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
  end
  
  describe "GET show" do
    it "should redirect invalid requests" do
      get :show, :id => 'foo'
      response.should be_redirect
    end
    
    it "should show an existing scenario" do
      @user_scenario = Factory :user_scenario
      get :show, :id => @user_scenario.id
      response.should be_success
      assigns(:user_scenario).should == @user_scenario
    end    
  end
  
  describe "POST create" do
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
        post :create, :user_scenario => @valid_attributes
        response.should redirect_to(scenario_path(assigns(:user_scenario)))
      }.should change(UserScenario, :count)
    end
    
    it "should not save a scenario with invalid parameters" do
      lambda {
        post :create, :user_scenario => @valid_attributes.merge(:name => '')
        response.should render_template(:new)
      }.should_not change(UserScenario, :count)
    end    
  end
  
  describe "GET compare" do
    it "should compare scenarios" do
      @scenarios = Array.new(3).map { Factory :user_scenario }
      get :compare, :ids => @scenarios.map(&:id)
      response.should be_success
    end
  end
end
