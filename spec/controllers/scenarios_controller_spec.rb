require 'spec_helper'

describe ScenariosController do
  render_views

  describe "GET index" do
    before do
      @scenarios = FactoryGirl.create_list(
        :scenario, 3, question_set: default_question_set)
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
    let!(:question) do
      create :question,
        :question_set => default_question_set,
        :text_en      => 'My correct question'
    end

    let!(:dashboard_item) do
      create :dashboard_item,
        :question_set => default_question_set,
        :label        => 'My correct dashboard item'
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET show" do
    before do
      # We're introducing some coupling here
      [ 5, 6, 7, 8 ].each do |number|
        create(:dashboard_item,
          gquery:       Scenario::Outputs[:"output_#{number}"],
          question_set: default_question_set)
      end
    end

    it "should redirect invalid requests" do
      get :show, :id => 'foo'
      response.should be_redirect
    end

    it "should show an existing scenario" do
      @scenario = create :scenario, question_set: default_question_set
      get :show, :id => @scenario.id
      response.should be_success
      assigns(:scenario).should == @scenario
    end
  end

  describe "GET answers" do
    it "should work" do
      @scenario = create :scenario, question_set: default_question_set
      get :show, :id => @scenario.id
      response.should be_success
      assigns(:scenario).should == @scenario
    end
  end

  describe "POST create" do
    before do
      @valid_attributes = attributes_for(:scenario)
      question = create :question, question_set: default_question_set

      @valid_attributes.merge(
        :question_set_id => question.question_set_id,

        :answers_attributes => {
          :question_id     => question.id,
          :answer_id       => question.answers.first.id
        }
      )
    end

    it "should save a valid scenario" do
      lambda {
        post :create, :scenario => @valid_attributes
        response.should redirect_to(scenario_path(assigns(:scenario)))
      }.should change(Scenario, :count)
    end

    it 'should set the question set' do
      post :create, :scenario => @valid_attributes
      assigns(:scenario).question_set.should eql(default_question_set)
    end

    it 'should not allow customising the question set' do
      post :create, :scenario => @valid_attributes.merge(:question_set_id => 1337)
      assigns(:scenario).question_set_id.should eql(default_question_set.id)
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
      @scenarios = FactoryGirl.create_list(
        :scenario, 3, question_set: default_question_set)

      get :compare, :ids => @scenarios.map(&:id)
      response.should be_success
    end
  end
end
