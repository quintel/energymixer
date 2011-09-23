class @Score
  constructor: (app) ->
    @app = app
    @values =
      mixer_co2_reduction_from_1990:
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
    this.setup_interface_callbacks()

  co2_score: ->
    v = @values.mixer_co2_reduction_from_1990
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
    score = (v.mark - v.current) / 1000
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
    this.co2_score() +
    this.renewability_score() +
    this.costs_score() +
    this.footprint_score() +
    this.dependence_score()

  update_interface: ->
    total = parseInt(this.total_score())
    $("#score table .cost").html(sprintf("%.2f", this.costs_score()))
    $("#score table .co2").html(sprintf("%.2f", this.co2_score()))
    $("#score table .renewables").html(sprintf("%.2f", this.renewability_score()))
    $("#score table .areafp").html(sprintf("%.2f", this.footprint_score()))
    $("#score table .import").html(sprintf("%.2f", this.dependence_score()))
    $("#score .value").html(total)
    $("input#scenario_score").val(total)
    $("#score .explanation").hide() if !this.should_show_score_explanation()
    # update subscore, too
    # current_questions starts with 1, while rails nested attributes with 0
    current_question_dom_id = @app.questions.current_question - 1
    input_selector = "#scenario_answers_attributes_" + current_question_dom_id + "_score"
    $(input_selector).val(total)

  refresh: ->
    for own key, value of @values
      return false if (value.mark == null || value.current == null)
    this.update_interface()
  
  setup_interface_callbacks: ->
    # show popup when user clicks question mark next to score
    $("#score #show_info").click =>
      $("#score .score_details").toggle()
      if this.should_show_score_explanation()
        $("#score .explanation").show()
      else
        $("#score .explanation").hide()

  should_show_score_explanation: ->
    @score == false && @app.questions.current_question <= 2
