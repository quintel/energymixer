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
    console.log(tipX);
    var tipY = e.pageY - 0;
    console.log(tipY);
    var height = parseFloat($(this).parents(".charts_container").find(".renewables_float").css("height"));
    $(".renewables_float").css({"top": tipY - height/2 , "left": tipX + 15});
  });
});