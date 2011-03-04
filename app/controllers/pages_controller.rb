class PagesController < ApplicationController
  def home
    @questions = Question.ordered.all
  end
end
