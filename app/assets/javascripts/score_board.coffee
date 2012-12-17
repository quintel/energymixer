class @ScoreBoard extends Backbone.View
  initialize: ->
    @score = false
    @values =
      mixer_reduction_of_co2_emissions_versus_1990:
        mark: null
        current : null
      mixer_renewability:
        mark: null
        current: null
      mixer_bio_footprint:
        mark: null
        current: null
      mixer_net_energy_import:
        mark: null
        current: null
      mixer_total_costs:
        mark: null
        current: null
  el: 'body'

  events:
    "click #score" : "toggle_score"

  update_values: (gqueries) ->
    for own key, values of @values
      v = gqueries[key]
      values.current = v
      values.mark = v if @model.questions.current_question == 2

  co2_score: ->
    v = @values.mixer_reduction_of_co2_emissions_versus_1990
    score = 0
    if (v.mark > v.current)
      score = Math.abs((v.mark - v.current) * 100)
    score

  renewability_score: ->
    v = @values.mixer_renewability
    score = (v.current - v.mark) * 100
    score = 0 if (score < 0)
    score

  costs_score: ->
    v = @values.mixer_total_costs
    score = (v.mark - v.current) / 100000000
    score = 0 if (score < 0)
    score

  footprint_score: ->
    v = @values.mixer_bio_footprint
    score = (v.mark - v.current) * 100
    score = 0 if (score < 0)
    score

  dependence_score: ->
    v = @values.mixer_net_energy_import
    score = (v.mark - v.current) * 100
    score = 0 if (score < 0)
    score

  total_score: ->
    @co2_score() +
    @renewability_score() +
    @costs_score() +
    @footprint_score() +
    @dependence_score()

  render: ->
    for own key, value of @values
      return false if (value.mark == null || value.current == null)

    @score = +@total_score().toFixed()
    $(".score_details table .cost").html @costs_score().toFixed(2)
    $(".score_details table .co2").html @co2_score().toFixed(2)
    $(".score_details table .renewables").html @renewability_score().toFixed(2)
    $(".score_details table .areafp").html @footprint_score().toFixed(2)
    $(".score_details table .import").html @dependence_score().toFixed(2)
    $("#score .value").html(@score)
    $("input#scenario_score").val(@score)
    $(".score_details .explanation").hide() if !@should_show_score_explanation()
    # update subscore, too
    # current_questions starts with 1, while rails nested attributes with 0
    current_question_dom_id = @model.questions.current_question - 1
    input_selector = "#scenario_answers_attributes_#{current_question_dom_id}_score"
    $(input_selector).val(@score)

  toggle_score: (e) =>
    $(".score_details").toggle()
    explanation = $(e.target).find(".explanation")
    if @should_show_score_explanation()
      explanation.show()
    else
      explanation.hide()

  should_show_score_explanation: ->
    @score == false && @model.questions.current_question <= 2
