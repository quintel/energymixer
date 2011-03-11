class AnswersController < ApplicationController
  layout 'admin'
  
  before_filter :find_answer
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  def edit
    4.times{ @answer.inputs.build }
  end
  
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to(@answer.question, :notice => 'Answer was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def update
    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(@answer.question, :notice => 'Answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :notice => "Something was wrong" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
    def find_answer
      @answer = Answer.find(params[:id])
    end
end
