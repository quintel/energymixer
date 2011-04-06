$(document).ready(function(){
  $("#partners .partner")
  .mousemove(function(e){
    var tipX = e.pageX - 18;
    var tipY = e.pageY - 64;
    var offset = $(this).offset();
    $(this).find(".content").css({"top": tipY -offset.top , "left": tipX - offset.left});
  });
  $(".partner_container").hover(function(){
    var con = $(this).attr("id") + "_content";
    $("#"+con).show();
  }
  ,function(){
    var con = $(this).attr("id") + "_content";
    $('#'+con).hide();
  });
});