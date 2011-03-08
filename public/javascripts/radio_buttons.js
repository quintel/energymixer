$(document).ready(function(){
  $("input[type='radio']").change(function(){
      console.log('Question changed to answer id:' + $(this).attr('id') + ' changed.');
  });
});