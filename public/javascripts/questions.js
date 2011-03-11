$(document).ready(function(){
  //probably move this to the html, because it might show in the interface when page loads slowly, DS
  $(".question").not("#question_1").hide();
  $("#question_1").addClass('active_question');

  $("#next_question").click(function(){
    $(".active_question").removeClass('active_question').hide().next().addClass('active_question').show();
    return false;
  });
  $("#previous_question").click(function(){
    $(".active_question").removeClass('active_question').hide().prev().addClass('active_question').show();
    return false;
  });


  $("input[type='radio']").change(function(){
    var id = $(this).attr('id');
    //console.log('Question changed to answer id:' + id + ' changed.');
    mixer.refresh();
    $(this).parent().parent().find("label").removeClass('active');
    $("label[for=" + id + "]").addClass('active');
  });
  
  mixer = new Mixer();
  
});