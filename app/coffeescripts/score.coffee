class @Score
  constructor: (app) ->
    @app = app
    @values =
      mixer_co2_reduction_from_1990:
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
      total_amount:
        mark: null
        current: null
    this.setup_interface_callbacks()
  
  calculate: ->
    for own key, value of @values
      return false if (value.mark == null || value.current == null)
    
    # DEBT: this should really be refactored into individual methods
    v = @values.total_amount
    a = (v.mark - v.current) / 1000
    a = 0 if (a < 0)
    
    v = @values.mixer_co2_reduction_from_1990
    b = 0
    if (v.mark > v.current)
      b = Math.abs((v.mark - v.current) * 100)
    
    v = @values.mixer_renewability
    c = (v.current - v.mark) * 100
    c = 0 if (c < 0)
    
    v = @values.mixer_bio_footprint
    d = (v.mark - v.current) * 100
    d = 0 if (d < 0)
    
    v = @values.mixer_net_energy_import
    e = (v.mark - v.current) * 100
    e = 0 if (e < 0)
    
    $("#score .cost").html(sprintf("%.2f", a))
    $("#score .co2").html(sprintf("%.2f", b))
    $("#score .renewables").html(sprintf("%.2f", c))
    $("#score .areafp").html(sprintf("%.2f", d))
    $("#score .import").html(sprintf("%.2f", e))

    return a + b + c + d + e
  
  show: ->
    @score = this.calculate()
    if (@score != false && @app.questions.current_question > 2)
      $("#dashboard #score .value").html(parseInt(@score))
      $("#dashboard #score").show()
      $("input#scenario_score").val(@score)
      $("#score .explanation").hide() if !this.should_show_score_explanation()
      
      # update subscore, too
      # current_questions starts with 1, while rails nested attributes with 0
      current_question_dom_id = @app.questions.current_question - 1
      input_selector = "#scenario_answers_attributes_" + current_question_dom_id + "_score"
      $(input_selector).val(@score)
  
  setup_interface_callbacks: ->
    # show popup when user clicks question mark next to score
    $("#score #show_info").click =>
      $("#score .details").toggle()
      if this.should_show_score_explanation()
        $("#score .explanation").show()
      else
        $("#score .explanation").hide()
        
  should_show_score_explanation: ->
    @score == false && @app.questions.current_question <= 2
