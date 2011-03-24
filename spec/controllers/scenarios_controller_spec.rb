require 'spec_helper'

describe ScenariosController do
  render_views

  describe "GET index" do
    before do
      @scenarios = Array.new(3).map { Factory :scenario }
    end
    
    it "should show a list of existing scenarios" do
      get :index
      response.should be_success
      assigns(:scenarios).to_set.should == @scenarios.to_set
      
    end
    
    it "should show a list of existing scenarios filtered by name" do
      get :index, :q => 'impossible'
      response.should be_success
      assigns(:scenarios).should be_empty
    end
  end
  
  describe "GET 'new'" do
    before do
      2.times { Factory :question }
      2.times { Factory :dashboard_item }
      a1 = Question.first.answers.first
      a2 = Question.last.answers.first
      a1.add_conflicting_answer(a2)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
  end
  
  describe "GET show" do
    before do
      # We're introducing some coupling here
      Factory.create(:dashboard_item, :gquery => Scenario::Outputs[:output_5])
      Factory.create(:dashboard_item, :gquery => Scenario::Outputs[:output_6])
      Factory.create(:dashboard_item, :gquery => Scenario::Outputs[:output_7])
      Factory.create(:dashboard_item, :gquery => Scenario::Outputs[:output_8])
    end
    
    it "should redirect invalid requests" do
      get :show, :id => 'foo'
      response.should be_redirect
    end
    
    it "should show an existing scenario" do
      @scenario = Factory :scenario
      get :show, :id => @scenario.id
      response.should be_success
      assigns(:scenario).should == @scenario
    end    
  end
  
  describe "POST create" do
    before do
      @valid_attributes = Factory.attributes_for(:scenario)
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
        post :create, :scenario => @valid_attributes
        response.should redirect_to(scenario_path(assigns(:scenario)))
      }.should change(Scenario, :count)
    end
    
    it "should not save a scenario with invalid parameters" do
      lambda {
        post :create, :scenario => @valid_attributes.merge(:name => '')
        response.should render_template(:new)
      }.should_not change(Scenario, :count)
    end    
  end
  
  describe "GET compare" do
    it "should compare scenarios" do
      @scenarios = Array.new(3).map { Factory :scenario }
      get :compare, :ids => @scenarios.map(&:id)
      response.should be_success
    end
  end
end
