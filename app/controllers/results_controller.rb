class ResultsController < ApplicationController
  layout 'admin'

  def index
    @results = Result.all
  end
  
  def edit
    @result = Result.find(params[:id])
  end

  def update
    @result = Result.find(params[:id])
    
    if @result.update_attributes(params[:result])
      redirect_to results_path, :notice => 'Result was successfully updated.'
    else
      render :action => "edit"
    end
    
  end

end