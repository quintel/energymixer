/* DO NOT MODIFY. This file was compiled Tue, 13 Sep 2011 10:14:29 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/scenario_picker.coffee
 */

(function() {
  $(function() {
    $(".selectable .scenario input").attr("checked", false);
    $("#selected .scenario input").attr("checked", true);
    $(".selectable .scenario input").live('change', function() {
      var element;
      if ($("#selected_scenarios input:checked").length >= 2) {
        $(this).attr('checked', false);
        alert("Je kunt maximaal 2 scenario's kiezen");
        return false;
      }
      $(this).attr('checked', true);
      element = $(this).closest("div.scenario");
      element.appendTo("#selected_scenarios");
      return element.find(".actions").hide();
    });
    $("#compare_with_user_scenario").change(function() {
      if ($("#selected input:checked").length >= 1) {
        $(this).attr('checked', false);
        alert("Je kunt maximaal 1 scenario's kiezen");
        return false;
      }
    });
    return $("body").ajaxStart(function() {
      return $("#user_scenarios").busy({
        img: '/images/spinner.gif'
      });
    });
  });
}).call(this);
