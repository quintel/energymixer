require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::ScenariosController do
  render_views
  let(:user) { create :user }

  before do
    sign_in user
  end

  before do
    @scenario = create :scenario
  end

  describe "GET index" do
    it "assigns all scenarios as @scenarios" do
      get :index
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested scenario as @scenario" do
      get :show, :id => @scenario.id
      assigns(:scenario).should == @scenario
      response.should be_success
    end

    it "should handle gracefully a missing record" do
      get :show, :id => 'foobar'
      response.should be_redirect      
    end
  end

  describe "GET new" do
    it "assigns a new scenario as @scenario" do
      get :new
      response.should be_success
    end
  end

  describe "GET edit" do
    it "shows the edit scenario form" do
      get :edit, :id => @scenario.id
      assigns(:scenario).should == @scenario
      response.should render_template('edit')
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new scenario" do
        lambda {
          post :create, :scenario => attributes_for(:scenario).
            merge(question_set_id: @scenario.question_set_id)

          response.should redirect_to(admin_scenario_url(assigns(:scenario)))
        }.should change(Scenario, :count)
      end
    end

    describe "with invalid params" do
      it "should show the form again" do
        post :create, :scenario => { :name => '' }
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested scenario" do
        put :update, :id => @scenario.id, :scenario => attributes_for(:scenario)
        response.should redirect_to(admin_scenario_url(@scenario))
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, :id => @scenario.id, :scenario => { :name => '' }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested scenario" do
      lambda {
        delete :destroy, :id => @scenario.id
        response.should redirect_to(admin_scenarios_url)
      }.should change(Scenario, :count)
    end
  end
end
