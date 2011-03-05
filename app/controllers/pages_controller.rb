class PagesController < ApplicationController
  def home
    @questions = Question.ordered.all
  end
  
  def mix
    render :layout => 'naked'
  end
end
