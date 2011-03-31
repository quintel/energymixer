require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::PopupsController do
  render_views
  let!(:popup) { Factory :popup }
  let(:user) { Factory :user }

  before do
    sign_in user
  end

  describe "GET index" do
    it "assigns all popups as @popups" do
      get :index
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested popup as @popup" do
      get :show, :id => popup.id
      assigns(:popup).should == popup
      response.should be_success
    end

    it "should handle gracefully a missing record" do
      get :show, :id => 'foobar'
      response.should be_redirect      
    end
  end

  describe "GET new" do
    it "assigns a new popup as @popup" do
      get :new
      response.should be_success
    end
  end

  describe "GET edit" do
    it "shows the edit popup form" do
      get :edit, :id => popup.id
      assigns(:popup).should == popup
      response.should render_template('edit')
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new popup" do
        lambda {
          post :create, :popup => Factory.attributes_for(:popup)
          response.should redirect_to(admin_popup_url(assigns(:popup)))
        }.should change(Popup, :count)
      end
    end

    describe "with invalid params" do
      it "should show the form again" do
        post :create, :popup => { :title => '' }
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    before do
      @popup = Factory :popup
    end

    describe "with valid params" do
      it "updates the requested popup" do
        put :update, :id => @popup.id, :popup => Factory.attributes_for(:popup)
        response.should redirect_to(admin_popup_url(@popup))
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, :id => @popup.id, :popup => { :code => '' }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @popup = Factory :popup
    end

    it "destroys the requested popup" do
      lambda {
        delete :destroy, :id => @popup.id
        response.should redirect_to(admin_popups_url)
      }.should change(Popup, :count)
    end
  end
end