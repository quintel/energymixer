class PagesController < ApplicationController
  def home
    @questions = Question.ordered.all
  end
  
  def mix
    render :layout => 'naked'
  end
  
  def httptest
    @response = HTTParty.get('http://twitter.com/statuses/public_timeline.json')
  end
end
