$(document).ready(function(){
  // hover on renewables
  $(".chart .renewable").hover(
    function(){
      $(this).parents(".charts_container").find(".renewables_float").show();
    },
    function(){
      $(".renewables_float").hide();
    }
  ).mousemove(function(e){
    var tipX = e.pageX - 0;
    var tipY = e.pageY - 0;
    var height = parseFloat($(this).parents(".charts_container").find(".renewables_float").css("height"));
    console.log(height);
    $(".renewables_float").css({"top": tipY - height/2 , "left": tipX + 15});
  });
});