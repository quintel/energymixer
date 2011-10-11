class App extends Backbone.Model
  initialize: ->
    @mixer = new Mixer(this)
    @chart = new Chart(this)
    @questions = new Questions(this)
    @score = new Score(this)

$ ->
  window.app = new App