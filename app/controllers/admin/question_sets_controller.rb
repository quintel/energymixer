class Admin::QuestionSetsController < AdminController
  set_tab :question_sets
  
  before_filter :find_question_set, :only => [:show, :edit, :update, :destroy]
  
  def index
    @question_sets = QuestionSet.all
  end
  
  def show
  end
  
  def edit
  end
  
  private
  
    def find_question_set
      @question_set = QuestionSet.find params[:id]
    end
end