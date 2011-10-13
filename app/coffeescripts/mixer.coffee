# This objects handles the core mixer functionality.
# For the output it depends on the Graph object and it
# requires some parameters to be set in the globals hash,
# namely api_base_path and api_session_settings
class Mixer extends Backbone.Model
  initialize: ->
    @chart     = new Chart({model: this})
    @questions = new Questions({model: this})
    @score     = new ScoreBoard({model: this})

    @base_path        = globals.api_base_path + "/api_scenarios"
    @scenario_id      = false
    @parameters       = {} # parameters set according to user answers
    @results          = {} # semiraw response from the engine
    @user_answers     = [] # right from the form
    @carriers_values  = {} # used by chart, too!
    @dashboard_values = {} # idem
    @secondary_carriers_values  = {}
    @gquery_results   = {} # clean results hash
    @dashboard_items     = globals.dashboard_items # provided by the controller
    @mix_table           = globals.mix_table       # idem
    @secondary_mix_table = globals.secondary_mix_table # idem
    @gqueries = @mix_table.concat(@dashboard_items).concat(@secondary_mix_table).concat(["mixer_total_costs"])
    @score_enabled = globals.score_enabled
    this.fetch_scenario_id()

  fetch_scenario_id: ->
    return @scenario_id if @scenario_id
    $.ajax(
      url: "#{@base_path}/new.json"
      dataType: 'jsonp'
      data: { settings : globals.api_session_settings }
      success: (data) =>
        key = data.api_scenario.id || data.api_scenario.api_session_key
        @scenario_id = key
        @chart.update_etm_link "#{globals.etm_scenario_base_url}/#{@scenario_id}/load?locale=nl"
        $.logThis("New scenario id: #{key}")
        # show data for the first time
        @make_request()
      error: (request, status, error) -> 
        $.logThis(error)
      )
    return @scenario_id
  
  # saving results to local variables in human readable format
  # store data in hidden form inputs too
  store_results: ->
    results = @results.result
    
    # let's store all values in the corresponding hidden inputs
    for own key, raw_results of results
      value = raw_results[1][1]
      @gquery_results[key] = value
      $("input[type=hidden][data-label=#{key}]").val(value)

    # total cost is used fairly often, let's save it in the mixer object
    @total_cost = results["mixer_total_costs"][1][1]
    
    # now let's udpate the result collections
    for own index, code of @mix_table
      @carriers_values[code] = @gquery_results[code]

    for own index, code of @secondary_mix_table
      @secondary_carriers_values[code] = @gquery_results[code]

    for own index, code of @dashboard_items
      value = @gquery_results[code]
      @dashboard_values[code] = value      
    
    # let's pass the data to the score object
    @score.update_values @gquery_results
    
  
  # sends the current parameters to the engine, stores
  # the results and triggers the interface update
  make_request: ->
    request_parameters = {result: @gqueries, reset: 1}
    request_parameters['input'] = @parameters unless $.isEmptyObject(@parameters)
    
    # Note that we're not using the standard jquery ajax call,
    # but http:#code.google.com/p/jquery-jsonp/
    # for its better error handling.
    # http://stackoverflow.com/questions/1002367/jquery-ajax-jsonp-ignores-a-timeout-and-doesnt-fire-the-error-event
    # if we're going back to vanilla jquery change the callback parameters,
    # add type: json and remove the '?callback=?' url suffix
    api_url = "#{@base_path}/#{this.fetch_scenario_id()}.json?callback=?"
    
    @chart.block_interface()
    $.jsonp(
      url: api_url,
      data: request_parameters,
      success: (data) =>
        # if(data.errors.length > 0) { alert(data.errors); }
        @results = data
        this.store_results()
        @chart.refresh()
        @score.render()
      error: (data, error) =>
        @chart.unblock_interface()
        $.logThis(error)
    )
    return true;
  
  set_parameter: (id, value) ->
    @parameters[id] = value
    return @parameters
  
  # build parameters given user answers. The parameter values are defined in the
  # global answer hash.
  build_parameters: ->
    @parameters = {}
    for own index, item of @user_answers
      question_id = item[0]
      answer_id   = item[1]
      # globals.answers is defined on the view!
      for own param_key, val of globals.answers[question_id][answer_id]
        this.set_parameter(param_key, val)
  
  # makes an array out of user answers in this format:
  # [ [question_1_id, answer_1_id], [question_2_id, answer_2_id], ...]
  process_form: ->
    @user_answers = [];
    for elem in $("div.question ul.answers input:checked")
      obj = $(elem)
      question_id = obj.data('question_id')
      @user_answers.push([question_id, parseInt(obj.val())])
    this.build_parameters()
    return @parameters
  
  # parses form, prepares parametes, makes ajax request and refreshes the chart
  # called every time the user selects an answer
  refresh: ->
    this.process_form()
    this.make_request()

$ ->
  window.app = new Mixer