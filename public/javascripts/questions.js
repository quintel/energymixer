function Questions() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.current_question = 1;
  
  self.count_questions = function() {
    self.num_questions = self.num_questions || $(".question").size();
    return self.num_questions;
  };
  
  self.show_right_question = function() {
    $(".question").hide();
    var question_id = "#question_" + self.current_question;
    $(question_id).show();
    // update top row
    $("a.question_tab").removeClass('active');
    var tab_selector = "a.question_tab[data-question_id=" + self.current_question + "]";
    $(tab_selector).addClass('active');
    // update links
    self.current_question == 1 ? 
      $("#previous_question").hide() : $("#previous_question").show();
    self.current_question == self.count_questions() ? 
      $("#next_question").hide() : $("#next_question").show();    
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
  self.question_number_for_answer = function(answer_id) {
    self.answers2questions = {};
    $("div.question input:checked").each(function(el) {
      self.answers2questions[$(this).val()] =  $(this).data('question_number');
    });
    return self.answers2questions[answer_id];
  };
  
  self.check_conflicts = function() {
    var conflicts = false;
    var conflicting_questions = [];
        
    $.each(self.currently_selected_answers(), function(index, answer_id){
      if(x = self.check_conflicting_answer(answer_id)) {
        conflicts = true;
        conflicting_questions.push(self.question_number_for_answer(answer_id));
      }
    });
    
    if (conflicts) {
      var text = unique(conflicting_questions).join(" and ");
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
      var conflicting_answers = globals.answers_conflicts[answer_id];
      if ($.inArray(parseInt(selected_answer_id), conflicting_answers) != -1) {
        conflict = selected_answer_id;
      }
    });
    return conflict;
  };
  
  // return the question id given the answer id
  self.get_answer_question_id = function(answer_id) {
    
  };
  
  self.setup_callbacks = function() {
    $("#next_question").click(function(){
      self.current_question++;
      var last_question = self.count_questions();
      if (self.current_question > last_question) self.current_question = last_question;
      self.show_right_question();
      return false;
    });

    $("#previous_question").click(function(){
      self.current_question--;
      if (self.current_question < 1) self.current_question = 1;
      self.show_right_question();      
      return false;
    });

    $("#questions nav#up a").click(function(){
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
    });
    
    // setup colorbox popups
    $(".question .text a").colorbox({
      width: "50%",
      height: "50%",
      opacity: 0.6
    });
    
    $(".question a.text_toggler").click(function(){
      var text_element = $(this).parent().find(".text");
      text_element.toggle();
      $(this).html(text_element.is(':visible') ? 'Lees minder' : 'Lees meer');
      return false;
    });
    
    $("form").submit(function(){
      $("#scenario_id").val(mixer.scenario_id);
    });
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
  };
  
  self.init();
};

$(document).ready(function(){
  graph = new Graph();
  mixer = new Mixer();
  q = new Questions();
});
