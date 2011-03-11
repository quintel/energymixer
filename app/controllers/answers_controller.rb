class AnswersController < ApplicationController
  layout 'admin'
  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    4.times{ @answer.inputs.build }
  end

  def update
    @answer = Answer.find(params[:id])    
    
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
end
