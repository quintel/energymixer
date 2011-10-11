class @Score extends Backbone.View
  initialize: ->
    @values =
      mixer_reduction_of_co2_emissions_versus_1990:
        mark: null
        current : null
        score: 0
      mixer_renewability:
        mark: null
        current: null
        score: 0
      mixer_bio_footprint:
        mark: null
        current: null
        score: 0
      mixer_net_energy_import:
        mark: null
        current: null
        score: 0
      mixer_total_costs:
        mark: null
        current: null
        score: 0
  el: 'body'

  events:
    "click #score" : "toggle_score"

  co2_score: ->
    v = @values.mixer_reduction_of_co2_emissions_versus_1990
    score = 0
    if (v.mark > v.current)
      score = Math.abs((v.mark - v.current) * 100)
    v.score = score

  renewability_score: ->
    v = @values.mixer_renewability
    score = (v.current - v.mark) * 100
    score = 0 if (score < 0)
    v.score = score

  costs_score: ->
    v = @values.mixer_total_costs
    score = (v.mark - v.current) / 100000000
    score = 0 if (score < 0)
    v.score = score

  footprint_score: ->
    v = @values.mixer_bio_footprint
    score = (v.mark - v.current) * 100
    score = 0 if (score < 0)
    v.score = score

  dependence_score: ->
    v = @values.mixer_net_energy_import
    score = (v.mark - v.current) * 100
    score = 0 if (score < 0)
    v.score = score
  
  total_score: ->
    @co2_score() +
    @renewability_score() +
    @costs_score() +
    @footprint_score() +
    @dependence_score()

  update_interface: ->
    total = parseInt(@total_score())
    $(".score_details table .cost").html(sprintf("%.2f", @costs_score()))
    $(".score_details table .co2").html(sprintf("%.2f", @co2_score()))
    $(".score_details table .renewables").html(sprintf("%.2f", @renewability_score()))
    $(".score_details table .areafp").html(sprintf("%.2f", @footprint_score()))
    $(".score_details table .import").html(sprintf("%.2f", @dependence_score()))
    $("#score .value").html(total)
    $("input#scenario_score").val(total)
    $("#score .explanation").hide() if !@should_show_score_explanation()
    # update subscore, too
    # current_questions starts with 1, while rails nested attributes with 0
    current_question_dom_id = @model.questions.current_question - 1
    input_selector = "#scenario_answers_attributes_#{current_question_dom_id}_score"
    $(input_selector).val(total)

  refresh: ->
    for own key, value of @values
      return false if (value.mark == null || value.current == null)
    @update_interface()
  
  toggle_score: (e) =>
    $(".score_details").toggle()
    explanation = $(e.target).find(".explanation")
    if @should_show_score_explanation()
      explanation.show()
    else
      explanation.hide()

  should_show_score_explanation: ->
    @score == false && @model.questions.current_question <= 2
