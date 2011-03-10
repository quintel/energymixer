class PagesController < ApplicationController

  def home
    @questions = Question.ordered.all
    @answers = Answer.where(:id => answer_ids).includes(:inputs)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def mix
    render :layout => 'naked'
  end

protected

  def answer_ids
    @answer_ids ||= request.query_parameters.select{|key, _| key.starts_with?('question_')}.values
  end
end
