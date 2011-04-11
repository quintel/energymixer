$(document).ready(function(){
    // graph labels auto show/hide
    $("ul.chart li").hover(
      function(){
        var height = $(this).height();
        if(height < 12) {
          $(this).data('expanded', true)
          $(this).css({"height": height + 10});
          $(this).find(".label").show();
        }
      },
      function(){
        if($(this).data('expanded')) {
          var height = $(this).height();
          $(this).data('expanded', false)
          $(this).css({"height": height - 10});
          $(this).find(".label").hide();          
        }
      });
});
