class Admin::QuestionSetsController < AdminController  
  before_filter :find_question_set, :only => [:show, :edit, :update, :destroy]
  
  def index
    @question_sets = QuestionSet.all
  end
  
  def show
  end
  
  def new
    @question_set = QuestionSet.new
  end
  
  def create
    @question_set = QuestionSet.new(params[:question_set])
    if @question_set.save
      redirect_to [:admin, @question_set], :notice => 'Question Set created'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @question_set.update_attributes(params[:question_set])
      redirect_to [:admin, @question_set], :notice => 'Question set updated'
    else
      render :edit
    end
  end
  
  def destroy
    @question_set.destroy
    redirect_to admin_question_sets_path, :notice => 'Question Set deleted'
  end
  
  private
  
    def find_question_set
      @question_set = QuestionSet.find params[:id]
    end
end
