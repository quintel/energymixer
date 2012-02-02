class Admin::AnswersController < AdminController
  before_filter :find_answer

  def show
  end

  def edit
    4.times{ @answer.inputs.build }
  end

  def destroy
    @answer.destroy
    redirect_to(admin_question_path(@answer.question), :notice => 'Answer was successfully deleted.')
  end

  def update
    # otherwise we wouldn't be removing conflicts
    params[:answer][:conflicting_answer_ids] ||= []
    if @answer.update_attributes(params[:answer])
      redirect_to(admin_question_path(@answer.question), :notice => 'Answer was successfully updated.')
    else
      render :action => "edit", :notice => "Something was wrong"
    end
  end

  private

    def find_answer
      @answer = Answer.find(params[:id])
    end
end
