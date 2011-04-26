function Questions() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.current_question = 1;
  
  // question methods
  //
  
  self.current_question_was_answered = function() {
    var question_id = "#question_" + self.current_question;
    var answer = $(question_id).find("input:checked");
    return answer.length > 0;
  };
  
  self.count_questions = function() {
    self.num_questions = self.num_questions || $(".question").size();
    return self.num_questions;
  };
  
  self.currently_selected_answers = function() {
    var answers = [];
    $(".answers .active input[type=radio]").each(function(){
      answers.push(parseInt($(this).val()));
    });
    return answers;
  };
  
  // returns the question_number given the answer_id we're using 
  // this method to alert the user about conflicting answers
  self.get_question_id_from_answer = function(answer_id) {
    self.answers2questions = {};
    $("div.question input:checked").each(function(el) {
      self.answers2questions[$(this).val()] =  $(this).data('question_number');
    });
    return self.answers2questions[answer_id];
  };
  
  self.check_conflicts = function() {
    var conflicts = false;
    var conflicting_questions = [];
        
    $.each(self.currently_selected_answers(), function(index, current_answer_id){
      if(conflicting_answer_id = self.check_conflicting_answer(current_answer_id)) {
        conflicts = true;
        conflicting_questions.push(self.get_question_id_from_answer(current_answer_id));
        conflicting_questions.push(self.get_question_id_from_answer(conflicting_answer_id));
      }
    });
    
    if (conflicts) {
      var text = unique(conflicting_questions).join(" en ");
      $("#questions #notice .conflicting_questions").html(text);
      $("#questions #notice").show();
    } else {
      $("#questions #notice").hide();
    }
  };
  
  // returns false or the conflicting answer_id
  self.check_conflicting_answer = function(selected_answer_id) {
    var conflict = false;
    var currently_selected_answers = self.currently_selected_answers();
    $.each(currently_selected_answers, function(index, answer_id){
      var conflicting_answers = globals.answers_conflicts[answer_id] || [];
      if ($.inArray(parseInt(selected_answer_id), conflicting_answers) != -1) {
        conflict = selected_answer_id;
      }
    });
    return conflict;
  };
  
  // interface methods
  //
  
  self.update_question_links = function() {
    var first_question = self.current_question == 1;
    var last_question  = self.current_question == self.count_questions();
    
    if (first_question) {
      $("#previous_question").hide();
    } else {
      $("#previous_question").show();
      if (last_question) { $("#next_question").hide(); }
    }
    
    if (self.current_question_was_answered() && !last_question) { 
      $("#next_question").show(); 
    } else {
      $("#next_question").hide();
    }
  };
  
  self.show_right_question = function() {
    $(".question").hide();
    var question_id = "#question_" + self.current_question;
    $(question_id).show();
    // update top row
    $(".question_tab").removeClass('active');
    var tab_selector = ".question_tab[data-question_id=" + self.current_question + "]";
    $(tab_selector).addClass('active');
    self.update_question_links();
    
    // GA
    var question_text = $.trim($(question_id).find("div.text").text());
    if (self.current_question == self.count_questions()) { question_text = "Saving scenario"; }
    var event_label = "" + self.current_question + " : " + question_text;
    self.track_event('opens_question', question_text, self.current_question);
  };
  
  // callbacks
  //
  
  self.setup_navigation_callbacks = function() {
    $("#next_question").click(function(){
      if(!self.current_question_was_answered()) {
        alert('Kies eerst een antwoord voor u verder gaat.');
      }
      else{
        self.current_question++;
        var last_question = self.count_questions();
        if (self.current_question > last_question) self.current_question = last_question;
        self.show_right_question();
      }
      return false;
    });

    $("#previous_question").click(function(){
      self.current_question--;
      if (self.current_question < 1) self.current_question = 1;
      self.show_right_question();      
      return false;
    });

    $("#questions nav#up a, #admin_menu a").click(function(){
      var question_id = $(this).data('question_id');
      self.current_question = question_id;
      self.show_right_question();
      return false;
    });
  };
  
  self.setup_cosmetic_callbacks = function(){
    // setup colorbox popups for below questions
    $(".question .information a").not(".no_popup").not(".iframe").colorbox({
      width: 600,
      opacity: 0.6
    });
    
    // setup colorbox popups for below questions
    $(".question .information a.iframe").colorbox({
      width: 600,
      height: 400,
      opacity: 0.6,
      iframe: true
    });

    // setup small tooltips
    $(".answers em").hover(
      function(){
        if ($(this).attr('key')){
          var key = $(this).attr('key');
        }
        else{
          var key = $(this).html();
        }
        var text = globals.popups[key]
        $("#tooltip h3").html(text.title);
        $("#tooltip div").html(text.body);
        $("#tooltip").show("fast");
      },
      function(){
        $("#tooltip").hide();
      }
    ).mousemove(function(e){
      var tipX = e.pageX - 0;
      var tipY = e.pageY - 0;
      var offset = $(this).offset();
      $("#tooltip").css({"top": tipY + 20 , "left": tipX});
    });
  };
  
  self.setup_callbacks = function() {
    self.setup_navigation_callbacks();
    self.setup_cosmetic_callbacks();
    
    // when the users clicks on an answer
    $("input[type='radio']").change(function(){
      var element = $(this).closest("li.answer");
      // remove active class from other answer
      element.parent().find("li.answer").removeClass('active');
      element.addClass('active');
      mixer.refresh();
      self.check_conflicts();
      self.update_question_links();
    });
    
    $("form").submit(function(){
      // update the scenario id hidden field
      $("#scenario_etm_scenario_id").val(mixer.scenario_id);
    });
  };
  
  // utility methods
  //
  
  self.clear_the_form = function(){
    $('form')[0].reset(); //we need to force this when a user refreshes the page (browser wants to remember the values), DS
  };
  
  self.track_event = function(action, label, value){
    if (typeof(_gaq) == "undefined") return;
    // http://code.google.com/apis/analytics/docs/tracking/asyncMigrationExamples.html#EventTracking
    _gaq.push(['_trackEvent', 'questions', action, label, value]);
  };
    
  self.init = function() {
    if($(".field_with_errors").length > 0) {
      // show the final form tab
      self.current_question = self.count_questions();
    } else {
      self.current_question = 1;
    }
    self.setup_callbacks();
    self.show_right_question();
    self.clear_the_form();
  };
  
  self.init();
};

// main application initialization

$(document).ready(function(){
  graph = new Graph();
  mixer = new Mixer();
  q = new Questions();
});
