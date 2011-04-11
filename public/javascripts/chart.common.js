$(document).ready(function(){
    // graph labels hover auto show/hide
    $("ul.chart li").hover(
      function(){
        var height = $(this).height();
        if(height < 12) {
          // remember we are expanding this one
          $(this).data('expanded', true)
          $(this).css({"height": height + 10});
          $(this).find(".label").show();
        }
      },
      function(){
        // collapse only those we had previously expanded
        if($(this).data('expanded')) {
          var height = $(this).height();
          $(this).data('expanded', false)
          $(this).css({"height": height - 10});
          $(this).find(".label").hide();          
        }
      });
});
