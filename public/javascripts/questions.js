function Questions() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.current_question = 1;
  
  self.show_right_question = function() {
    console.log("Current question:" + self.current_question);
    $(".active_question").removeClass('active_question');
    $(".question").hide();
    var question_id = "#question_" + self.current_question;
    $(question_id).addClass('active_question').show();
    // update top row
    $("a.question_tab").removeClass('active');
    var tab_selector = "a.question_tab[data-question_id=" + self.current_question + "]";
    $(tab_selector).addClass('active');
  };
  
  self.setup_callbacks = function() {
    // move this logic in markup and css
    $(".question").not("#question_1").hide();
    $("#question_1").addClass('active_question');

    $("#next_question").click(function(){
      self.current_question++;
      self.show_right_question();
      return false;
    });

    $("#previous_question").click(function(){
      self.current_question--;
      self.show_right_question();      
      return false;
    });

    $("#questions nav#up a").click(function(){
      var question_id = $(this).attr('data-question_id');
      self.current_question = question_id;
      self.show_right_question();
      return false;
    });

    /*
    //  Changing labels
    */
    $("input[type='radio']").change(function(){
      var id = $(this).attr('id');
      mixer.refresh();
      $(this).parent().parent().find("label").removeClass('active');
      $("label[for=" + id + "]").addClass('active');
    });
    
    // Graph layout 
    //
  };
  
  self.setup_graph_callbacks = function() {
    $("#solid_view").click(function(){
      $("#mixholder").removeClass("cilinder").addClass("solid");
    });

    $("#3d_view").click(function(){
      $("#mixholder").removeClass("solid").addClass("cilinder");
    });
  };
  
  self.init = function() {
    self.setup_callbacks();
    self.setup_graph_callbacks();
    self.show_right_question();
  };
  
  self.init();
};

$(document).ready(function(){
  mixer = new Mixer();
  q = new Questions();
});
