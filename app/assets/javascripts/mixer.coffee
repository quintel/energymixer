# This objects handles the core mixer functionality.
# For the output it depends on the Graph object and it
# requires some parameters to be set in the globals hash,
# namely api_base_path and api_session_settings
class Mixer extends Backbone.Model
  initialize: ->
    @chart     = new Chart({model: this})
    @questions = new Questions({model: this})
    @score     = new ScoreBoard({model: this})
    @gqueries  = globals.gqueries
    @base_path = @base_url() + "/api_scenarios"
    @score_enabled = globals.config.score_enabled
    @fetch_scenario_id()

  fetch_scenario_id: ->
    return @scenario_id if @scenario_id
    $.ajax
      url: "#{@base_path}/new.json"
      data: { settings : globals.api.session_settings }
      success: (data) =>
        # api_scenario = pre-July deploy, scenario = post deploy
        scenario_data = data.scenario || data.api_scenario
        key = scenario_data.id || scenario_data.api_session_key

        @scenario_id = key
        @chart.update_etm_link "#{globals.api.load_in_etm_url}/#{@scenario_id}/load?locale=nl"
        $.logThis("New scenario id: #{key}")
        # show data for the first time
        @make_request()
      error: (request, status, error) -> $.logThis(error)
    return @scenario_id

  # saving results to local variables in human readable format
  # store data in hidden form inputs too
  store_results: (results) ->
    # let's store all values in the corresponding hidden inputs
    @gquery_results ||= {}
    for own key, raw_results of results
      value = raw_results[1][1]
      @gquery_results[key] = value
      $("input[type=hidden][data-label=#{key}]").val(value)

    # let's pass the data to the score object
    @score.update_values @gquery_results

  # flat list of all the gqueries we're sending to the engine
  all_gqueries: ->
    return @_all_gqueries if @_all_gqueries
    @_all_gqueries = []
    for key in ['primary', 'secondary', 'dashboard', 'costs']
      @_all_gqueries = @_all_gqueries.concat(_.values(@gqueries[key]))
    @_all_gqueries

  # sends the current parameters to the engine, stores
  # the results and triggers the interface update
  make_request: ->
    request_parameters = {result: @all_gqueries(), reset: 1}
    request_parameters['input'] = @parameters unless $.isEmptyObject(@parameters)
    api_url = "#{@base_path}/#{this.fetch_scenario_id()}.json"

    @chart.block_interface()
    $.ajax
      url: api_url,
      data: request_parameters,
      success: (data) =>
        @store_results(data.result)
        @chart.render()
        @score.render()
      error: (data, error) =>
        @chart.unblock_interface()
        $.logThis(error)
    return true

  # build parameters given user answers. The parameter values are defined in the
  # global answer hash.
  build_parameters: ->
    @parameters = {}
    for own index, item of @user_answers
      question_id = item[0]
      answer_id   = item[1]
      # globals.answers is defined on the view!
      for own param_key, val of globals.answers[question_id][answer_id]
        @parameters[param_key] = val

  # makes an array out of user answers in this format:
  # [ [question_1_id, answer_1_id], [question_2_id, answer_2_id], ...]
  process_form: ->
    @user_answers = []
    for elem in $("div.question ul.answers input:checked")
      obj = $(elem)
      question_id = obj.data('question_id')
      @user_answers.push([question_id, parseInt(obj.val())])
    @build_parameters()
    @parameters

  # parses form, prepares parametes, makes ajax request and refreshes the chart
  # called every time the user selects an answer
  refresh: ->
    @process_form()
    @make_request()

  # returns the base API URL according to proxy and CORS support
  base_url: ->
    if jQuery.support.cors && !globals.api.disable_cors
        globals.api.url
    else
        globals.api.proxy_url
$ ->
  window.app = new Mixer
