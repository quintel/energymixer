function Questions() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.current_question = 1;
  
  self.current_question_was_answered = function() {
    var question_id = "#question_" + self.current_question;
    var answer = $(question_id).find("input:checked");
    return answer.length > 0;
  };
  
  self.show_next_question_link_if_needed = function() {
    //self.current_question_was_answered() ? $("#next_question").show() : $("#next_question").hide();
  };
  
  self.count_questions = function() {
    self.num_questions = self.num_questions || $(".question").size();
    return self.num_questions;
  };
  
  self.show_right_question = function() {
    $(".question").hide();
    var question_id = "#question_" + self.current_question;
    $(question_id).show();
    // update top row
    $(".question_tab").removeClass('active');
    var tab_selector = ".question_tab[data-question_id=" + self.current_question + "]";
    $(tab_selector).addClass('active');
    // update links
    self.current_question == 1 ? 
      $("#previous_question").hide() : $("#previous_question").show();
    self.current_question == self.count_questions() ? 
      $("#next_question").hide() : $("#next_question").show();
    self.show_next_question_link_if_needed();
    
    self.track_event("show_question", self.current_question);
  };
  
  self.currently_selected_answers = function() {
    var answers = [];
    $(".answers .active input[type=radio]").each(function(){
      answers.push(parseInt($(this).val()));
    });
    return answers;
  };
  
  // returns the question_number given the answer_id
  // we're using this method to alert the user about
  // conflicting answers
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
  
  self.setup_callbacks = function() {
    $("#next_question").click(function(){
      if(!self.current_question_was_answered()) {
        alert('Kies eerst een antwoord voor je verder gaat.');
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
    
    // when the users clicks on an answer
    $("input[type='radio']").change(function(){
      $(this).parent().parent().find("li.answer").removeClass('active');
      $(this).parent().addClass('active');
      mixer.refresh();
      self.check_conflicts();
      self.show_next_question_link_if_needed();
    });
    
    // setup colorbox popups for below questions
    $(".question .information a").not(".no_popup").not(".iframe").colorbox({
      width: 600,
      height: 300,
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
        
    $(".question a.text_toggler").click(function(){
      var text_element = $(this).parent().find(".text");
      text_element.toggle();
      $(this).html(text_element.is(':visible') ? 'Lees minder' : 'Lees meer');
      return false;
    });
    
    $("form").submit(function(){
      $("#scenario_etm_scenario_id").val(mixer.scenario_id);
    });
  };
  
  self.clear_the_form = function(){
    $('form')[0].reset(); //we need to force this when a user refreshes the page (browser wants to remember the values), DS
  };
  
  self.track_event = function(key, value){
    if (!_gaq) return;
    _gaq.push(['_trackEvent', key, value]);
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

$(document).ready(function(){
  graph = new Graph();
  mixer = new Mixer();
  q = new Questions();
});
