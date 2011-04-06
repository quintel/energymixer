$(function(){
  $("ul.answers li label").click(function(){
    $(this).parent().find("input[type=radio]").click().click();
  });
});