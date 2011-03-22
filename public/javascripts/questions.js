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
    //update links
    self.current_question == 1 ? 
      $("#previous_question").hide() : $("#previous_question").show();
    self.current_question == self.count_questions() ? 
      $("#next_question").hide() : $("#next_question").show();
    
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
  };
    
  self.init = function() {
    self.current_question = 1;
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
