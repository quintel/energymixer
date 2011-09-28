/* DO NOT MODIFY. This file was compiled Wed, 28 Sep 2011 14:00:22 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/popups.coffee
 */

(function() {
  $(function() {
    $.blockUI.defaults.overlayCSS.backgroundColor = "#ffffff";
    $.blockUI.defaults.overlayCSS.opacity = 0.6;
    $.blockUI.defaults.baseZ = 500;
    $.blockUI.defaults.message = null;
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
      popup = $(this).parent().find(".popup").toggle();
      return $(this).closest(".full_chart").block();
    });
    return $(".full_chart .dashboard_item a.close_popup").click(function() {
      $(this).parent().hide();
      return $(this).closest(".full_chart").unblock();
    });
  });
}).call(this);
