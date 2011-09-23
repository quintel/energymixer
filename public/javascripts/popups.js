/* DO NOT MODIFY. This file was compiled Fri, 23 Sep 2011 12:17:59 GMT from
 * /Users/dennisschoenmakers/apps/mixer/app/coffeescripts/popups.coffee
 */

(function() {
  $(function() {
    $("ul.chart li.renewable").hover(function() {
      return $(this).parents(".charts_container").find(".renewables_float").show();
    }, function() {
      return $(".renewables_float").hide();
    });
    $(".renewables_float").click(function() {
      return $(this).hide();
    });
    $(".full_chart .dashboard_item .info_icon").click(function() {
      var key;
      key = $(this).parent().attr('id');
      return $(this).parents(".full_chart").find("#dashboard_popups ." + key).toggle();
    });
    return $(".full_chart #dashboard_popups a.close_popup").click(function() {
      return $(this).parent().hide();
    });
  });
}).call(this);
