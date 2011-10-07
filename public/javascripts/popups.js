/* DO NOT MODIFY. This file was compiled Fri, 07 Oct 2011 09:25:49 GMT from
 * /Users/robbertdol/Sites/energymixer/app/coffeescripts/popups.coffee
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
      if (is_not_ie7()) {
        return $(this).closest(".full_chart").block();
      };
    });
    return $(".full_chart .dashboard_item .popup").click(function() {
      $(this).closest(".full_chart").unblock();
      return $(this).hide();
    });
  });
}).call(this);
