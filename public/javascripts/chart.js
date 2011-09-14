/* DO NOT MODIFY. This file was compiled Wed, 14 Sep 2011 08:25:43 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/chart.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  this.Chart = (function() {
    function Chart(app) {
      this.app = app;
      this.dashboard_steps = window.globals.dashboard_steps;
      this.mixer = this.app.mixer;
    }
    Chart.prototype.refresh = function() {
      var key, value, _ref;
      _ref = this.mixer.dashboard_values;
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        value = _ref[key];
        this.update_dashboard_item(key, value);
      }
      return this.update_bar_chart();
    };
    Chart.prototype.block_interface = function() {
      $("#dashboard .dashboard_item .value, .user_created .total_amount, #carriers").busy({
        img: '/images/spinner.gif'
      });
      return this.app.questions.hide_all_question_links();
    };
    Chart.prototype.unblock_interface = function() {
      $("#dashboard .dashboard_item .value, .user_created .total_amount, #carriers").busy("clear");
      return this.app.questions.update_question_links();
    };
    Chart.prototype.update_dashboard_item = function(key, value) {
      var class_to_add, classes_to_remove, dashboard_selector, formatted_value, i, step;
      dashboard_selector = "#dashboard ." + key;
      formatted_value = this.format_dashboard_value(key, value);
      $("" + dashboard_selector + " .value").html(formatted_value);
      step = this.find_step_for_dashboard_item(key, value);
      classes_to_remove = '';
      for (i = 0; i <= 10; i++) {
        classes_to_remove += "" + key + "_step_" + i + " ";
      }
      class_to_add = "" + key + "_step_" + step;
      return $(dashboard_selector).removeClass(classes_to_remove).addClass(class_to_add);
    };
    Chart.prototype.find_step_for_dashboard_item = function(key, value) {
      var i, step, steps, _i, _len;
      steps = this.dashboard_steps[key];
      step = 0;
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        i = steps[_i];
        if (value > i) {
          step += 1;
        }
      }
      return step;
    };
    Chart.prototype.format_dashboard_value = function(key, value) {
      var out;
      out = "";
      switch (key) {
        case "co2_emission_percent_change_from_1990_corrected_for_electricity_import":
          if (value > 0) {
            out = "+";
          }
          out += sprintf("%.1f", value * 100) + "%";
          break;
        case "area_footprint_per_nl":
          out = sprintf("%.2f", value) + "xNL";
          break;
        case "share_of_renewable_energy":
        case "energy_dependence":
          out = sprintf("%.1f", value * 100) + "%";
          break;
        default:
          out = value;
      }
      return out;
    };
    Chart.prototype.update_bar_chart = function() {
      var chart_max_height, code, current_chart_height, current_sum, label, max_amount, new_height, new_money_height, renewable_subchart_height, rounded_sum, selector, total_renewable_amount, val, _ref, _ref2;
      current_sum = this.mixer.gquery_results["policy_total_energy_cost"] * 1000;
      this.app.score.values.total_amount.current = current_sum;
      if (this.app.questions.current_question === 2 && this.app.score.values.total_amount.mark === null) {
        this.app.score.values.total_amount.mark = current_sum;
      }
      chart_max_height = 390;
      max_amount = globals.chart_max_amount / 1000000;
      current_chart_height = current_sum / max_amount * chart_max_height;
      rounded_sum = 0;
      _ref = this.mixer.carriers_values;
      for (code in _ref) {
        if (!__hasProp.call(_ref, code)) continue;
        val = _ref[code];
        new_height = Math.round(val / current_sum * current_chart_height);
        rounded_sum += new_height;
        selector = ".user_created ." + code;
        $(selector).animate({
          "height": new_height
        }, "slow");
        label = $("" + selector + " .label");
        if (new_height > 10) {
          label.show();
        } else {
          label.hide();
        }
      }
      renewable_subchart_height = 100;
      total_renewable_amount = this.app.mixer.carriers_values.costs_share_of_sustainable;
      _ref2 = this.app.mixer.secondary_carriers_values;
      for (code in _ref2) {
        if (!__hasProp.call(_ref2, code)) continue;
        val = _ref2[code];
        new_height = Math.round(val / total_renewable_amount * renewable_subchart_height);
        selector = ".user_created ." + code;
        $(selector).animate({
          "height": new_height
        }, "slow");
        label = $("" + selector + " .label");
        if (new_height > 5) {
          label.show();
        } else {
          label.hide();
        }
      }
      new_money_height = rounded_sum + 4 * 2;
      $(".user_created .money").animate({
        "height": new_money_height
      }, "slow");
      $(".user_created .total_amount span").html(sprintf("%.1f", current_sum / 1000));
      return this.unblock_interface();
    };
    Chart.prototype.update_etm_link = function() {
      return $("footer a").click(__bind(function(e) {
        if (confirm("Wilt u meteen de gekozen instellingen zien in het Energietransitiemodel? (zo nee, dan gaat u naar de homepage van het Energietransitiemodel)")) {
          return $(e.target).attr("href", this.mixer.etm_scenario_url);
        }
      }, this));
    };
    return Chart;
  })();
}).call(this);
