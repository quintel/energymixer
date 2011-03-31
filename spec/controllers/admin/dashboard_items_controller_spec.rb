require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::DashboardItemsController do
  render_views  
  let!(:dashboard_item) { Factory :dashboard_item }
  let(:user) { Factory :user }

  before do
    sign_in user
  end

  describe "GET index" do
    it "assigns all dashboard_items as @dashboard_items" do
      get :index
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested dashboard_item as @dashboard_item" do
      get :show, :id => dashboard_item.id
      assigns(:dashboard_item).should == dashboard_item
      response.should be_success
    end

    it "should handle gracefully a missing record" do
      get :show, :id => 'foobar'
      response.should be_redirect      
    end
  end

  describe "GET new" do
    it "assigns a new dashboard_item as @dashboard_item" do
      get :new
      response.should be_success
    end
  end

  describe "GET edit" do
    it "shows the edit dashboard_item form" do
      get :edit, :id => dashboard_item.id
      assigns(:dashboard_item).should == dashboard_item
      response.should render_template('edit')
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new dashboard_item" do
        lambda {
          post :create, :dashboard_item => Factory.attributes_for(:dashboard_item)
          response.should redirect_to(admin_dashboard_item_url(assigns(:dashboard_item)))
        }.should change(DashboardItem, :count)
      end
    end

    describe "with invalid params" do
      it "should show the form again" do
        post :create, :dashboard_item => { :label => '' }
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    before do
      @dashboard_item = Factory :dashboard_item
    end
    
    describe "with valid params" do
      it "updates the requested dashboard_item" do
        put :update, :id => @dashboard_item.id, :dashboard_item => Factory.attributes_for(:dashboard_item)
        response.should redirect_to(admin_dashboard_item_url(@dashboard_item))
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, :id => @dashboard_item.id, :dashboard_item => { :label => '' }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @dashboard_item = Factory :dashboard_item
    end
    
    it "destroys the requested dashboard_item" do
      lambda {
        delete :destroy, :id => @dashboard_item.id
        response.should redirect_to(admin_dashboard_items_url)
      }.should change(DashboardItem, :count)
    end
  end
end