class @Questions extends Backbone.View
  initialize: ->
    @current_question = 1
    @popups = window.globals.popups
    # If the user submits the form but the record is not saved
    # rails renders the template again. Let's show the final step
    if($(".field_with_errors").length > 0)
      # show the final form tab
      @current_question = this.count_questions()
    else
      @current_question = 1
    @show_right_question()
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
    "click .question a.show_info"        : "show_question_info_box"
    "click .question a.close_info_popup" : "hide_question_info_box"
    "mouseenter li.answer em"  : "show_tooltip"
    "mouseleave  li.answer em" : "hide_tooltip"
    "mousemove li.answer em"   : "move_tooltip"

  # Callbacks
  #

  setup_colorbox: ->
    $(".question .information .body a, .answer .text a").not(".no_popup").not(".iframe").colorbox({
      width: 600
      opacity: 0.6
    })

    $(".question .information a.iframe").colorbox({
      width: 600
      height: 400
      opacity: 0.6
      iframe: true
    })

  show_tooltip: (e) ->
    element = $(e.target)
    key = element.attr('key') || element.html()
    popup = @popups[key]
    return unless popup
    $("#tooltip h3").html(popup.title)
    $("#tooltip div").html(popup.body)
    $("#tooltip").show("fast")

  hide_tooltip: -> $("#tooltip").hide()

  move_tooltip: (e) ->
    tipX = e.pageX - 0
    tipY = e.pageY - 0
    offset = $(this).offset()
    $("#tooltip").css({"top": tipY + 20 , "left": tipX})

  hide_question_info_box: (e) =>
    e.preventDefault()
    $(e.target).closest(".information").hide()
    $(e.target).closest("#questions").unblock()
    $("nav#down").unblock()

  show_question_info_box: (e) =>
    e.preventDefault()
    $(e.target).closest(".info").find(".information").toggle()
    $(e.target).closest("#questions").block()
    $("nav#down").block()

  open_question: (e) =>
    e.preventDefault()
    question_id = $(e.target).data('question_id')
    @current_question = question_id
    @show_right_question()

  submit_form: =>
    # update the scenario id hidden field
    $("#scenario_etm_scenario_id").val(@model.scenario_id)
    @store_geolocation() if globals.config.geolocation_enabled
    @track_event('mixer', "submits form")

  select_answer: (e) =>
    element = $(e.target).closest("li.answer")
    # remove active class from other answer
    element.parent().find("li.answer").removeClass('active')
    element.addClass('active')
    @model.refresh()
    @check_conflicts()
  
  # question methods
  #
  question_was_answered: (question_id) ->
    elem = "#question_#{question_id}"
    answer = $(elem).find("input:checked")
    if answer.length > 0
      return answer
    else
      return false
  
  current_question_was_answered: ->
    @question_was_answered @current_question
  
  count_questions: ->
    @num_questions = @num_questions || $(".question").size()
    @num_questions
  
  currently_selected_answers: ->
    answers = []
    $(".answers .active input[type=radio]").each ->
      answers.push(parseInt($(this).val()))
    return answers

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
  
    $.each(@currently_selected_answers(), (index, current_answer_id) =>
      if(conflicting_answer_id = this.check_conflicting_answer(current_answer_id))
        conflicts = true
        conflicting_questions.push(@get_question_id_from_answer(current_answer_id))
        conflicting_questions.push(@get_question_id_from_answer(conflicting_answer_id))
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
    currently_selected_answers = @currently_selected_answers()
    for own index, answer_id of currently_selected_answers
      conflicting_answers = globals.answers_conflicts[answer_id] || []
      if ($.inArray(parseInt(selected_answer_id), conflicting_answers) != -1)
        conflict = selected_answer_id
    return conflict
  
  # interface methods
  #
  
  _goto_next_question: (e) =>
    e.preventDefault()
    if @current_question_was_answered()
      @current_question++
      last_question = this.count_questions()
      @current_question = last_question if @current_question > last_question
      @show_right_question()
  
  _goto_prev_question: (e) =>
    e.preventDefault()
    @current_question--
    @current_question = 1 if @current_question < 1
    @show_right_question()
  
  disable_prev_link: ->
    $("#previous_question").addClass('link_disabled')
    $("#previous_question").unbind('click')
  
  enable_prev_link: ->
    $("#previous_question").removeClass('link_disabled')
    $("#previous_question").unbind('click')
    $("#previous_question").bind 'click', @_goto_prev_question
  
  disable_next_link: ->
    $("#next_question").addClass('link_disabled')
    $("#next_question").unbind('click')
  
  enable_next_link: ->
    $("#next_question").removeClass('link_disabled')
    $("#next_question").unbind('click')
    $("#next_question").bind 'click', @_goto_next_question
  

  disable_all_question_links: =>
    @disable_next_link()
    @disable_prev_link()
  
  update_question_links: =>
    first_question = @current_question == 1
    last_question  = @current_question == @count_questions()
  
    if first_question
      @disable_prev_link()
    # We don't want the user to change his mind on the first two questions
    # to prevent score forging
    else if @current_question <= 3 && @model.score_enabled
      @disable_prev_link()
    else
      @enable_prev_link()
      @disable_next_link() if last_question
  
    if @current_question_was_answered() && !last_question
      @enable_next_link()
    else
      @disable_next_link()
  
  show_right_question: =>
    $(".question").hide()
    question_id = "#question_" + @current_question
    $(question_id).show()
    # update top row
    $(".question_tab").removeClass('active')
    for i in [1..@current_question]
      tab_selector = ".question_tab[data-question_id=#{i}]"
      $(tab_selector).addClass('active')
    @update_question_links()
  
    # GA
    previous_question_id = @current_question - 1
    if answer = @question_was_answered(previous_question_id)
      question_text = $.trim $("#question_#{previous_question_id} > .text").text()
      answer_container = answer.parent()
      answer_letter = $.trim answer_container.find(".number").text()
      # I convert the letter to a number because GA doesn't accept a string as parameter
      answer_number = answer_letter.charCodeAt(0) - 64
      answer_text   = $.trim answer_container.find(".text").text()
      @track_event('mixer', "##{previous_question_id}: #{question_text}", answer_text, answer_number)
  
  store_geolocation: =>
    navigator.geolocation.getCurrentPosition (pos) ->
      $("#scenario_longitude").val(pos.coords.longitude)
      $("#scenario_latitude").val(pos.coords.latitude)
  
  # utility methods
  #
  
  # we need to force this when a user refreshes the page (browser wants to remember the values), DS
  clear_the_form: -> $('form')[0].reset()
  
  track_event: (category, action, label, value) ->
    return if (typeof(_gaq) == "undefined")
    # http://code.google.com/apis/analytics/docs/tracking/asyncMigrationExamples.html#EventTracking
    _gaq.push(['_trackEvent', category, action, label, value])
