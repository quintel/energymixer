$(document).ready(function(){

  /*
  //  Navigating through the questions
  */

  $(".question").not("#question_1").hide();   //probably move this to the html, because it might show in the interface when page loads slowly, DS
  $("#question_1").addClass('active_question');

  $("#next_question").click(function(){
    $(".active_question").removeClass('active_question').hide().next().addClass('active_question').show();
    return false;
  });
  
  $("#previous_question").click(function(){
    $(".active_question").removeClass('active_question').hide().prev().addClass('active_question').show();
    return false;
  });
  
  $("#questions nav#up a").click(function(){
    $(".question").hide().removeClass('active_question');
    $("#" + $(this).attr('rel') ).show().addClass('active_question');
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
  
  mixer = new Mixer();
  
});