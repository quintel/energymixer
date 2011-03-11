class QuestionsController < AdminController
  def index
    @questions = Question.ordered.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
    5.times{ @question.answers.build }
  end

  def edit
    @question = Question.find(params[:id])
    5.times{ @question.answers.build }
  end

  def create
    @question = Question.new(params[:question])

    if @question.save
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      redirect_to(@question, :notice => 'Question was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to(questions_url, :notice => 'Question deleted')
  end
end
