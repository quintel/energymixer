class @Questions extends Backbone.View
  initialize: (app) ->
    @app = app
    @current_question = 1
    # If the user submits the form but the record is not saved
    # rails renders the template again. Let's show the final step
    if($(".field_with_errors").length > 0)
      # show the final form tab
      @current_question = this.count_questions()
    else
      @current_question = 1
    this.show_right_question()
    @setup_colorbox()
    @clear_the_form()

  el: 'body'

  events:
    "change input[type='radio']" : "select_answer"
    "submit form"                : "submit_form"
    "click #next_question"       : "_goto_next_question"
    "click #prev_question"       : "_goto_prev_question"
    "click #questions nav#up a"  : "open_question"
    "click #admin_menu a"        : "open_question"
    "click section#questions .question a.show_info" : "show_question_info_box"
    "click section#questions .question a.close_info_popup" : "hide_question_info_box"
    "mouseover .answers em" : "show_tooltip"
    "mouseout .answers em"  : "hide_tooltip"
    "mousemove .answers em" : "move_tooltip"

  # Callbacks
  #

  setup_colorbox: ->
    # setup colorbox popups for below questions
    $(".question .information a, .answer .text a").not(".no_popup").not(".iframe").colorbox({
      width: 600
      opacity: 0.6
    })

    # setup colorbox popups for below questions
    $(".question .information a.iframe").colorbox({
      width: 600
      height: 400
      opacity: 0.6
      iframe: true
    })

  show_tooltip: ->
    if ($(this).attr('key'))
      key = $(this).attr('key')
    else
      key = $(this).html()
    text = globals.popups[key]
    $("#tooltip h3").html(text.title)
    $("#tooltip div").html(text.body)
    $("#tooltip").show("fast")

  hide_tooltip: -> $("#tooltip").hide()

  move_tooltip: (e) ->
    tipX = e.pageX - 0
    tipY = e.pageY - 0
    offset = $(this).offset()
    $("#tooltip").css({"top": tipY + 20 , "left": tipX})

  hide_question_info_box: (e) ->
    e.preventDefault()
    $(e.target).closest(".information").hide()
    $(e.target).closest("#questions").unblock()
    $("nav#down").unblock()

  show_question_info_box: (e) ->
    $(e.target).parent().find(".information").toggle()
    e.preventDefault()
    $(e.target).closest("#questions").block()
    $("nav#down").block()

  open_question: (e) =>
    e.preventDefault()
    question_id = $(e.target).data('question_id')
    @current_question = question_id
    this.show_right_question()

  submit_form: =>
    # update the scenario id hidden field
    $("#scenario_etm_scenario_id").val(@app.mixer.scenario_id)
    this.store_geolocation() if globals.geolocation_enabled

  select_answer: (e) =>
    element = $(e.target).closest("li.answer")
    # remove active class from other answer
    element.parent().find("li.answer").removeClass('active')
    element.addClass('active')
    @app.mixer.refresh()
    this.check_conflicts()
    
  # question methods
  #
  current_question_was_answered: ->
    question_id = "#question_#{@current_question}"
    answer = $(question_id).find("input:checked")
    return answer.length > 0
  
  count_questions: ->
    @num_questions = @num_questions || $(".question").size()
    @num_questions
  
  currently_selected_answers: ->
    answers = []
    $(".answers .active input[type=radio]").each ->
      answers.push(parseInt($(this).val()))
    return answers

  reset_questions: ->
    for el in $(".answers input:checked")
      $(el).attr('checked', false)
      $(el).closest("li.answer").removeClass('active')
    app.mixer.refresh()
  
  # returns the question_number given the answer_id we're using 
  # this method to alert the user about conflicting answers
  get_question_id_from_answer: (answer_id) ->
    @answers2questions = {}
    for e in $("div.question input:checked")
      @answers2questions[$(e).val()] = $(e).data('question_number')
    return @answers2questions[answer_id]
  
  check_conflicts: ->
    conflicts = false
    conflicting_questions = []
        
    $.each(this.currently_selected_answers(), (index, current_answer_id) =>
      if(conflicting_answer_id = this.check_conflicting_answer(current_answer_id))
        conflicts = true
        conflicting_questions.push(this.get_question_id_from_answer(current_answer_id))
        conflicting_questions.push(this.get_question_id_from_answer(conflicting_answer_id))
    ) 
    
    if conflicts
      text = unique(conflicting_questions).join(" en ")
      $("section#conflicts .conflicting_questions").html(text)
      $("section#conflicts").show()
    else
      $("section#conflicts").hide()
  
  # returns false or the conflicting answer_id
  check_conflicting_answer: (selected_answer_id) ->
    conflict = false
    currently_selected_answers = this.currently_selected_answers()
    for own index, answer_id of currently_selected_answers
      conflicting_answers = globals.answers_conflicts[answer_id] || []
      if ($.inArray(parseInt(selected_answer_id), conflicting_answers) != -1)
        conflict = selected_answer_id
    return conflict
  
  # interface methods
  #
  
  _goto_next_question: (e) =>
    e.preventDefault()
    if this.current_question_was_answered()
      @current_question++
      last_question = this.count_questions()
      if (@current_question > last_question)
        @current_question = last_question
      this.show_right_question()
    
  _goto_prev_question: (e) =>
    e.preventDefault()
    @current_question--
    @current_question = 1 if (@current_question < 1)
    this.show_right_question()
    
  
  disable_prev_link: ->
    $("#previous_question").addClass('link_disabled')
    $("#previous_question").unbind('click')
  
  enable_prev_link: ->
    $("#previous_question").removeClass('link_disabled')
    $("#previous_question").unbind('click')
    $("#previous_question").bind 'click', this._goto_prev_question
  
  disable_next_link: ->
    $("#next_question").addClass('link_disabled')
    $("#next_question").unbind('click')
  
  enable_next_link: ->
    $("#next_question").removeClass('link_disabled')
    $("#next_question").unbind('click')
    $("#next_question").bind 'click', this._goto_next_question
  

  disable_all_question_links: =>
    this.disable_next_link()
    this.disable_prev_link()
  
  update_question_links: =>
    first_question = @current_question == 1
    last_question  = @current_question == this.count_questions()
    
    if first_question 
      this.disable_prev_link()
    # We don't want the user to change his mind on the first two questions
    # to prevent score forging
    else if @current_question <= 3 && @app.score_enabled
      this.disable_prev_link()
    else
      this.enable_prev_link()
      this.disable_next_link() if last_question
    
    if (this.current_question_was_answered() && !last_question)
      this.enable_next_link()
    else
      this.disable_next_link()
  
  show_right_question: =>
    $(".question").hide()
    question_id = "#question_" + @current_question
    $(question_id).show()
    # update top row
    $(".question_tab").removeClass('active')
    for i in [1..@current_question]
      tab_selector = ".question_tab[data-question_id=#{i}]"
      $(tab_selector).addClass('active')      
    this.update_question_links()
    
    # GA
    question_text = $.trim($(question_id).find("div.text").text())
    if (@current_question == this.count_questions())
      question_text = "Saving scenario"
    event_label = "#{@current_question} : #{question_text}"
    this.track_event("opens_question_#{@current_question}", question_text, @current_question)
  
  store_location: =>
    navigator.geolocation.getCurrentPosition (pos) ->
      $("#scenario_longitude").val(pos.coords.longitude)
      $("#scenario_latitude").val(pos.coords.latitude)
  
  # utility methods
  #
  
  # we need to force this when a user refreshes the page (browser wants to remember the values), DS
  clear_the_form: -> $('form')[0].reset()
  
  track_event: (action, label, value) ->
    return if (typeof(_gaq) == "undefined")
    # http:#code.google.com/apis/analytics/docs/tracking/asyncMigrationExamples.html#EventTracking
    _gaq.push(['_trackEvent', 'questions', action, label, value])
