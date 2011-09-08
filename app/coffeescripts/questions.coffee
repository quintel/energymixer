class @Questions
  constructor: (app) ->
    @app = app
    @current_question = 1
    if($(".field_with_errors").length > 0)
      # show the final form tab
      @current_question = this.count_questions()
    else
      @current_question = 1;
    this.setup_callbacks()
    this.show_right_question()
    this.clear_the_form()
    
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
  
  # returns the question_number given the answer_id we're using 
  # this method to alert the user about conflicting answers
  get_question_id_from_answer: (answer_id) ->
    @answers2questions = {}
    $("div.question input:checked").each (el) ->
      @answers2questions[$(this).val()] = $(this).data('question_number');
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
      $("#questions #notice .conflicting_questions").html(text)
      $("#questions #notice").show()
    else
      $("#questions #notice").hide()
  
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
  
  hide_all_question_links: ->
    $("#previous_question").hide()
    $("#nex_question").hide()
  
  update_question_links: ->
    first_question = @current_question == 1
    last_question  = @current_question == this.count_questions()
    
    if (first_question)
      $("#previous_question").hide()
    else
      $("#previous_question").show()
      $("#next_question").hide() if last_question
    
    if (this.current_question_was_answered() && !last_question)
      $("#next_question").show()
    else
      $("#next_question").hide()
  
  show_right_question: ->
    $(".question").hide()
    question_id = "#question_" + @current_question
    $(question_id).show()
    # update top row
    $(".question_tab").removeClass('active')
    tab_selector = ".question_tab[data-question_id=#{@current_question}]"
    $(tab_selector).addClass('active')
    this.update_question_links()
    
    # GA
    question_text = $.trim($(question_id).find("div.text").text())
    if (@current_question == this.count_questions())
      question_text = "Saving scenario"
    event_label = "#{@current_question} : #{question_text}"
    this.track_event('opens_question', question_text, @current_question)
  
  # callbacks
  #
  setup_navigation_callbacks: ->
    $("#next_question").click =>
      if(!this.current_question_was_answered())
        alert('Kies eerst een antwoord voor u verder gaat.')
      else
        @current_question++
        last_question = this.count_questions()
        if (@current_question > last_question)
          @current_question = last_question
        this.show_right_question()
      return false

    $("#previous_question").click =>
      @current_question--
      @current_question = 1 if (@current_question < 1) 
      this.show_right_question()
      return false

    $("#questions nav#up a, #admin_menu a").click ->
      question_id = $(this).data('question_id')
      @current_question = question_id
      this.show_right_question()
      return false
  
  setup_cosmetic_callbacks: ->
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
    });

    # setup small tooltips
    $(".answers em").hover(
      () ->
        if ($(this).attr('key'))
          key = $(this).attr('key')
        else
          key = $(this).html()
        text = globals.popups[key]
        $("#tooltip h3").html(text.title)
        $("#tooltip div").html(text.body)
        $("#tooltip").show("fast")
      ,
      () -> $("#tooltip").hide()
    )
    $(".answers em").mousemove (e) ->
      tipX = e.pageX - 0
      tipY = e.pageY - 0
      offset = $(this).offset()
      $("#tooltip").css({"top": tipY + 20 , "left": tipX})
  
  setup_callbacks: ->
    this.setup_navigation_callbacks()
    this.setup_cosmetic_callbacks()
    
    # when the users clicks on an answer
    $("input[type='radio']").change (e) =>
      element = $(e.target).closest("li.answer")
      # remove active class from other answer
      element.parent().find("li.answer").removeClass('active')
      element.addClass('active')
      @app.mixer.refresh()
      this.check_conflicts()
    
    $("form").submit =>
      # update the scenario id hidden field
      $("#scenario_etm_scenario_id").val(@app.mixer.scenario_id)
  
  # utility methods
  #
  
  clear_the_form: ->
    $('form')[0].reset() # we need to force this when a user refreshes the page (browser wants to remember the values), DS
  
  track_event: (action, label, value) ->
    return if (typeof(_gaq) == "undefined")
    # http:#code.google.com/apis/analytics/docs/tracking/asyncMigrationExamples.html#EventTracking
    _gaq.push(['_trackEvent', 'questions', action, label, value])
