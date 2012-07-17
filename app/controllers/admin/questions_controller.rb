class Admin::QuestionsController < AdminController
  before_filter :find_question, :only => [:show, :edit, :update, :destroy]
  
  def index
    @questions = @question_set.questions.ordered.all
  end

  def show
  end

  def new
    @question = Question.new
    5.times{ @question.answers.build }
  end

  def edit
    5.times{ @question.answers.build }
  end

  def create
    @question = @question_set.questions.build(params[:question])

    if @question.save
      redirect_to(admin_question_path(@question), :notice => 'Question was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @question.update_attributes(params[:question])
      redirect_to(admin_question_path(@question), :notice => 'Question was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @question.destroy
    redirect_to(admin_questions_url, :notice => 'Question deleted')
  end
  
  private
  
    def find_question
      @question = @question_set.questions.find(params[:id])
    end
end
