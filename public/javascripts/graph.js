function make_em_dance(max_height){
  if (max_height === undefined ) {
    param2 = '50';
   }
  var numbers = new Array();
  for (i=0;i<=5;i++){
    numbers.push(Math.random()*max_height);
  }

  carriers = ["gas","coal","uranium","renewable","oil"];

  for (index in carriers){
    $("#" + carriers[index]).animate({"height": numbers[index]}, "slow");
  }
}

$(document).ready(function(){
  
  $("#mixholder").click(function(){
    make_em_dance(80);
  });

});
