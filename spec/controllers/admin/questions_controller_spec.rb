require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe Admin::QuestionsController do
  render_views
  let!(:question) { Factory :question }
  let(:user) { Factory :user }

  before do
    sign_in user
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      get :index
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested question as @question" do
      get :show, :id => question.id
      assigns(:question).should == question
      response.should be_success
    end

    it "should handle gracefully a missing record" do
      get :show, :id => 'foobar'
      response.should be_redirect      
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      get :new
      response.should be_success
    end
  end

  describe "GET edit" do
    it "shows the edit question form" do
      get :edit, :id => question.id
      assigns(:question).should == question
      response.should render_template('edit')
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new question" do
        lambda {
          post :create, :question => { :question => 'hi there'}
          response.should redirect_to(admin_question_url(assigns(:question)))
        }.should change(Question, :count)
      end
    end

    describe "with invalid params" do
      it "should show the form again" do
        post :create, :question => { :question => '' }
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    before do
      @question = Factory :question
    end

    describe "with valid params" do
      it "updates the requested question" do
        put :update, :id => @question.id, :question => { :question => 'hi there' }
        @question.reload.question.should == 'hi there'
        response.should redirect_to(admin_question_url(@question))
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, :id => @question.id, :question => { :question => '' }
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @question = Factory :question
    end

    it "destroys the requested question" do
      lambda {
        delete :destroy, :id => @question.id
        response.should redirect_to(admin_questions_url)
      }.should change(Question, :count)
    end
  end
end