/* DO NOT MODIFY. This file was compiled Mon, 10 Oct 2011 09:45:11 GMT from
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
      $(".dashboard_item .value, .chart header, #carriers").busy({
        img: '/images/spinner.gif'
      });
      return this.app.questions.disable_all_question_links();
    };
    Chart.prototype.unblock_interface = function() {
      $(".dashboard_item .value, .chart header, #carriers").busy("clear");
      return this.app.questions.update_question_links();
    };
    Chart.prototype.update_dashboard_item = function(key, value) {
      var dashboard_item, formatted_value, gauge_icon, i, step;
      formatted_value = this.format_dashboard_value(key, value);
      dashboard_item = $(".dashboard_item#" + key);
      dashboard_item.find(".value").html(formatted_value);
      gauge_icon = dashboard_item.find('.gauge_icon');
      for (i = 0; i <= 10; i++) {
        gauge_icon.removeClass("" + key + "_step_" + i);
      }
      step = this.find_step_for_dashboard_item(key, value);
      return gauge_icon.addClass("" + key + "_step_" + step);
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
        case "mixer_reduction_of_co2_emissions_versus_1990":
          if (value > 0) {
            out = "+";
          }
          out += sprintf("%.1f", value * 100) + "%";
          break;
        case "mixer_bio_footprint":
          out = sprintf("%.2f", value) + "xNL";
          break;
        case "mixer_renewability":
        case "mixer_net_energy_import":
          out = sprintf("%.1f", value * 100) + "%";
          break;
        default:
          out = value;
      }
      return out;
    };
    Chart.prototype.update_bar_chart = function() {
      var chart_max_height, charts_to_be_updated, code, current_chart_height, current_sum, item, max_amount, new_height, percentage, ratio, selector, total_renewables_ratio, _ref, _ref2;
      current_sum = this.mixer.gquery_results["mixer_total_costs"];
      charts_to_be_updated = $(".charts_container").not('.static');
      this.app.score.values.mixer_total_costs.current = current_sum;
      if (this.app.questions.current_question === 2 && this.app.score.values.mixer_total_costs.mark === null) {
        this.app.score.values.mixer_total_costs.mark = current_sum;
      }
      chart_max_height = 360;
      max_amount = globals.chart_max_amount;
      current_chart_height = Math.sqrt(current_sum / max_amount) * chart_max_height;
      _ref = this.mixer.carriers_values;
      for (code in _ref) {
        if (!__hasProp.call(_ref, code)) continue;
        ratio = _ref[code];
        new_height = ratio * current_chart_height;
        item = charts_to_be_updated.find("li." + code);
        item.animate({
          "height": new_height
        }, "slow");
        percentage = Math.round(ratio * 100);
        selector = $(".legend tr." + code + " td.value");
        selector.html("" + percentage + "%");
      }
      chart_max_height = 160;
      total_renewables_ratio = this.app.mixer.gquery_results.mixer_renewability;
      _ref2 = this.app.mixer.secondary_carriers_values;
      for (code in _ref2) {
        if (!__hasProp.call(_ref2, code)) continue;
        ratio = _ref2[code];
        new_height = Math.round(ratio / total_renewables_ratio * chart_max_height);
        item = charts_to_be_updated.find("ul.chart ." + code);
        item.animate({
          "height": new_height
        }, "slow");
        percentage = Math.round(ratio * 100);
        selector = $(".legend tr." + code + " td.value");
        selector.html("" + percentage + "%");
      }
      $(".chart header span.total_amount").html(sprintf("%.1f", current_sum / 1000000000));
      return this.unblock_interface();
    };
    Chart.prototype.update_etm_link = function(url) {
      return $("footer a").click(__bind(function(e) {
        if (confirm("Wil je meteen de gekozen instellingen zien in het Energietransitiemodel? (zo nee, dan ga je naar de homepage van het Energietransitiemodel)")) {
          return $(e.target).attr("href", url);
        }
      }, this));
    };
    return Chart;
  })();
}).call(this);
