$(document).ready(function(){
  $("input[type='radio']").change(function(){
    var id = $(this).attr('id');
    //console.log('Question changed to answer id:' + id + ' changed.');
    mixer.refresh();
    $(this).parent().parent().find("label").removeClass('active');
    $("label[for=" + id + "]").addClass('active');
  });

  $("input[type='radio']").focus(function(){
    alert('focus!');
  }).blur(function(){
    alert('blur!');
  });

});