$(document).ready(function(){
  $("#next_question").click(function(){
    console.log("next clicked");
  });
  $("#previous_question").click(function(){
    console.log("previous clicked");
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