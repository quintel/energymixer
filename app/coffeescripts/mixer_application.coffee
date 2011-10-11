class App extends Backbone.Model
  initialize: ->
    @mixer = new Mixer(this)
    @chart = new Chart({model: this})
    @questions = new Questions({model: this})
    @score = new Score({model: this})

$ ->
  window.app = new App