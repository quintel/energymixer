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
    @score_enabled = globals.config.score_enabled

    @api = new ApiGateway
      api_path:           globals.api.url
      api_proxy_path:     globals.api.proxy_url
      offline:            globals.api.disable_cors
      # beforeLoading:      @showLoading
      # afterLoading:       @hideLoading
      source:             globals.api.session_settings.source
      area_code:          globals.api.session_settings.area_code
      end_year:           globals.api.session_settings.end_year
      preset_scenario_id: globals.api.session_settings.preset_id

    @api.ensure_id().done (id) =>
      @chart.update_etm_link "#{globals.api.load_in_etm}/#{id}/load?locale=nl"
      @make_request()

  # saving results to local variables in human readable format
  # store data in hidden form inputs too
  store_results: (results) ->
    # let's store all values in the corresponding hidden inputs
    @gquery_results ||= {}
    for own key, raw_results of results
      value = raw_results.future
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
  make_request: =>
    @chart.block_interface()
    @api.update
      queries: @all_gqueries()
      reset: true
      inputs: @parameters
      success: (data) =>
        @store_results(data.results)
        @chart.render()
        @score.render()
      error: (data, error) =>
        @chart.unblock_interface()
        console.error(error)

  # build parameters given user answers. The parameter values are defined in the
  # global answer hash.
  build_parameters: ->
    @parameters = {}
    for item in @user_answers
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
      @user_answers.push([question_id, +obj.val()])
    @build_parameters()
    @parameters

  # parses form, prepares parametes, makes ajax request and refreshes the chart
  # called every time the user selects an answer
  refresh: ->
    @process_form()
    @make_request()

$ ->
  window.app = new Mixer
