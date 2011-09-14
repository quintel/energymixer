# This objects handles the core mixer functionality.
# For the output it depends on the Graph object and it
# requires some parameters to be set in the globals hash,
# namely api_base_path and api_session_settings
class @Mixer
  constructor: (app) ->
    @app = app
    @base_path        = globals.api_base_path + "/api_scenarios"
    @session_id       = false
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
    @gqueries = @mix_table.concat(@dashboard_items).concat(@secondary_mix_table).concat(["policy_total_energy_cost"])
    this.fetch_session_id()

  fetch_session_id: ->
    return @session_id if @session_id
    $.ajax(
      url: "#{@base_path}/new.json"
      dataType: 'jsonp'
      data: { settings : globals.api_session_settings }
      success: (data) =>
        key = data.api_scenario.id || data.api_scenario.api_session_key
        @session_id = @scenario_id = key
        @app.chart.update_etm_link "#{globals.etm_scenario_base_url}/#{@scenario_id}/load?locale=nl"
        $.logThis("Fetched new session Key: #{key}")
        # show data for the first time
        this.make_request()
      error: (request, status, error) -> 
        $.logThis(error)
      )
    return @session_id
  
  json_path_with_session_id: ->
    "#{@base_path}/#{this.fetch_session_id()}.json"
      
  # saving results to local variables in human readable format
  # store data in hidden form inputs too
  store_results: ->
    results = @results.result
    
    # let's store all values in the corresponding hidden inputs
    for own key, raw_results of results
      value = raw_results[1][1]
      $("input[type=hidden][data-label=#{key}]").val(value)
      @gquery_results[key] = value

    # total cost is used fairly often, let's save it in the mixer object
    @total_cost = results["policy_total_energy_cost"][1][1]
    
    # now let's udpate the result collections
    for own index, code of @mix_table
      value = Math.round(@gquery_results[code]/1000000)
      @carriers_values[code] = value

    for own index, code of @secondary_mix_table
      value = Math.round(@gquery_results[code]/1000000)
      @secondary_carriers_values[code] = value

    for own index, code of @dashboard_items
      value = @gquery_results[code]
      @dashboard_values[code] = value
      
      # update scores object, which is based on dashboard values
      @app.score.values[code].current = value
      if (@app.questions.current_question == 2 && @app.score.values[code].mark == null)
        @app.score.values[code].mark = value;
  
  # sends the current parameters to the engine, stores
  # the results and triggers the interface update
  make_request: (hash) ->
    hash = @parameters if !hash
    request_parameters = {result: @gqueries, reset: 1}
    request_parameters['input'] = hash if(!$.isEmptyObject(hash))
    
    # Note that we're not using the standard jquery ajax call,
    # but http:#code.google.com/p/jquery-jsonp/
    # for its better error handling.
    # http:#stackoverflow.com/questions/1002367/jquery-ajax-jsonp-ignores-a-timeout-and-doesnt-fire-the-error-event
    # if we're going back to vanilla jquery change the callback parameters,
    # add type: json and remove the '?callback=?' url suffix
    @app.chart.block_interface()
    $.jsonp(
      url: this.json_path_with_session_id() + '?callback=?',
      data: request_parameters,
      success: (data) =>
        # if(data.errors.length > 0) { alert(data.errors); }
        @results = data
        this.store_results()
        @app.chart.refresh()
        @app.score.show()
      error: (data, error) ->
        @app.chart.unblock_interface()
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
