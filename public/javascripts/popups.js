/* DO NOT MODIFY. This file was compiled Tue, 20 Sep 2011 09:21:12 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/popups.coffee
 */

(function() {
  $(function() {
    $("ul.chart li.renewable").hover(function() {
      return $(this).parents(".charts_container").find(".renewables_float").show();
    }, function() {
      return $(".renewables_float").hide();
    });
    $(".full_chart .dashboard_item .info_icon").click(function() {
      var key;
      key = $(this).parent().attr('id');
      return console.log($(this).parents(".full_chart").find("#dashboard_popups ." + key).show());
    });
    return $(".full_chart #dashboard_popups a.close_popup").click(function() {
      return $(this).parent().hide();
    });
  });
}).call(this);
