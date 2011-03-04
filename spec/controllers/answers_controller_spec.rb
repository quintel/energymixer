require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe AnswersController do
  render_views
  
  let(:answer) { Factory :answer }

  describe "GET show" do
    it "assigns the requested answer as @answer" do
      get :show, :id => answer.id
      assigns(:answer).should == answer
      response.should be_success
    end
  end

  describe "GET edit" do
    it "assigns the requested answer as @answer" do
      get :edit, :id => answer.id
      assigns(:answer).should == answer
      response.should render_template('edit')
    end
  end

  describe "PUT update" do
    before do
      @answer = Factory :answer
    end

    describe "with valid params" do
      it "updates the requested answer" do
        put :update, :id => @answer.id, :answer => { :answer => 'Hi!'}
        assigns(:answer).should == @answer
        @answer.reload.answer.should == 'Hi!'
        response.should redirect_to(answer_url(@answer))
      end
    end

    describe "with invalid params" do
      it "assigns the answer as @answer" do
        put :update, :id => @answer.id, :answer => { :answer => '' }
        assigns(:answer).should == @answer
        response.should render_template('edit')
      end
    end
  end
end
