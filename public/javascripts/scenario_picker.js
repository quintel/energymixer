/* DO NOT MODIFY. This file was compiled Mon, 19 Sep 2011 09:26:09 GMT from
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
      element.find(".actions").hide();
      return element.find(".remove_from_list").show();
    });
    $(".scenario .remove_from_list a").live('click', function() {
      var item;
      item = $(this).parents(".scenario");
      item.find(".actions").show();
      item.find(".remove_from_list").hide();
      item.find("input").attr('checked', false);
      return item.appendTo('#user_scenarios');
    });
    $("#compare_with_user_scenario").change(function() {
      if ($("#selected input:checked").length >= 1) {
        $(this).attr('checked', false);
        alert("Je kunt maximaal 1 scenario's kiezen");
        return false;
      }
    });
    $("a.submit_form").click(function(e) {
      e.preventDefault();
      return $("section#select form").submit();
    });
    return $("body").ajaxStart(function() {
      return $("#user_scenarios").busy({
        img: '/images/spinner.gif'
      });
    });
  });
}).call(this);
