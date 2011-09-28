/* DO NOT MODIFY. This file was compiled Wed, 28 Sep 2011 12:01:51 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/popups.coffee
 */

(function() {
  $(function() {
    $("ul.chart li.renewables").hover(function() {
      return $(this).parents(".charts_container").find(".renewables_float").show();
    }, function() {
      return $(".renewables_float").hide();
    });
    $(".renewables_float").click(function() {
      return $(this).hide();
    });
    $(".full_chart .dashboard_item .info_icon").click(function() {
      var popup;
      return popup = $(this).parent().find(".popup").toggle();
    });
    return $(".full_chart .dashboard_item a.close_popup").click(function() {
      return $(this).parent().hide();
    });
  });
}).call(this);
