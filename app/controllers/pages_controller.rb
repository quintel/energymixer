class PagesController < ApplicationController
  def home
    @questions = Question.all
  end
  
  def mix
    render :layout => 'naked'
  end
end
