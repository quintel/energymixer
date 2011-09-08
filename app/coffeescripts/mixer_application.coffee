class @App
  constructor: ->
    @mixer = new Mixer(this)
    @graph = new Graph(this)
    @questions = new Questions(this)
    @score = new Score(this)

$ ->
  window.app = new App