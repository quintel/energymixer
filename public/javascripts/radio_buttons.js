$(document).ready(function(){
  $("input[type='radio']").change(function(){
      var id = $(this).attr('id');
      //console.log('Question changed to answer id:' + id + ' changed.');
      mixer.refresh();
      $("label[for=" + id + "]").addClass('active');
  });
});