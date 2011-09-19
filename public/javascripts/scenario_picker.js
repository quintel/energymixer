/* DO NOT MODIFY. This file was compiled Mon, 19 Sep 2011 11:51:01 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/scenario_picker.coffee
 */

(function() {
  var ScenarioPicker;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  ScenarioPicker = (function() {
    function ScenarioPicker() {
      this.setup_callbacks();
    }
    ScenarioPicker.prototype.setup_callbacks = function() {
      $(".selectable .scenario input").attr("checked", false);
      $("#selected .scenario input").attr("checked", true);
      $(".selectable .scenario input").live('change', __bind(function(e) {
        var element;
        if (this.selected_scenarios_count() >= 2) {
          $(e.target).attr('checked', false);
          alert("Je kunt maximaal 2 scenario's kiezen");
          return false;
        }
        $(e.target).attr('checked', true);
        element = $(e.target).closest("div.scenario");
        element.appendTo("#selected_scenarios");
        element.find(".actions").hide();
        element.find(".remove_from_list").show();
        return this.update_submit_link();
      }, this));
      $(".scenario .remove_from_list a").live('click', __bind(function(e) {
        var item;
        item = $(e.target).parents(".scenario");
        item.find(".actions").show();
        item.find(".remove_from_list").hide();
        item.find("input").attr('checked', false);
        item.appendTo('#user_scenarios');
        return this.update_submit_link();
      }, this));
      $("#compare_with_user_scenario").change(__bind(function(e) {
        if (this.selected_scenarios_count() >= 1) {
          $(e.target).attr('checked', false);
          alert("Je kunt maximaal 1 scenario's kiezen");
          return false;
        }
      }, this));
      $("a.submit_form").click(__bind(function(e) {
        e.preventDefault();
        if (this.selected_scenarios_count() === 2) {
          return $("section#select form").submit();
        }
      }, this));
      return $("body").ajaxStart(function() {
        return $("#user_scenarios").busy({
          img: '/images/spinner.gif'
        });
      });
    };
    ScenarioPicker.prototype.selected_scenarios_count = function() {
      return $("#selected_scenarios input:checked").length;
    };
    ScenarioPicker.prototype.update_submit_link = function() {
      if (this.selected_scenarios_count() < 2) {
        return $("a.submit_form").removeClass('enabled').addClass('disabled');
      } else {
        return $("a.submit_form").removeClass('disabled').addClass('enabled');
      }
    };
    return ScenarioPicker;
  })();
  $(function() {
    return new ScenarioPicker();
  });
}).call(this);
