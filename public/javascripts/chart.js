/* DO NOT MODIFY. This file was compiled Fri, 13 Jan 2012 09:44:25 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/chart.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  this.Chart = (function() {
    __extends(Chart, Backbone.View);
    function Chart() {
      Chart.__super__.constructor.apply(this, arguments);
    }
    Chart.prototype.initialize = function() {
      return this.dashboard_steps = globals.chart.dashboard_steps;
    };
    Chart.prototype.render = function() {
      var gquery, label, _ref;
      _ref = this.model.gqueries.dashboard;
      for (label in _ref) {
        if (!__hasProp.call(_ref, label)) continue;
        gquery = _ref[label];
        this.update_dashboard_item(gquery, this.model.gquery_results[gquery]);
      }
      return this.update_bar_chart();
    };
    Chart.prototype.block_interface = function() {
      $(".dashboard_item .value, .chart header, #carriers").busy({
        img: '/images/spinner.gif'
      });
      return this.model.questions.disable_all_question_links();
    };
    Chart.prototype.unblock_interface = function() {
      $(".dashboard_item .value, .chart header, #carriers").busy("clear");
      return this.model.questions.update_question_links();
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
      var chart_max_height, code, current_chart_height, current_sum, gquery, max_amount, new_height, ratio, total_renewables_ratio, _ref, _ref2;
      current_sum = this.model.gquery_results["mixer_total_costs"];
      chart_max_height = 360;
      max_amount = globals.chart.max_amount;
      current_chart_height = Math.sqrt(current_sum / max_amount) * chart_max_height;
      _ref = this.model.gqueries.primary;
      for (code in _ref) {
        if (!__hasProp.call(_ref, code)) continue;
        gquery = _ref[code];
        ratio = this.model.gquery_results[gquery];
        new_height = ratio * current_chart_height;
        this._animate_chart_item(code, new_height);
        this._update_legend_item(code, ratio);
      }
      chart_max_height = 160;
      total_renewables_ratio = this.model.gquery_results.mixer_renewability;
      _ref2 = this.model.gqueries.secondary;
      for (code in _ref2) {
        if (!__hasProp.call(_ref2, code)) continue;
        gquery = _ref2[code];
        ratio = this.model.gquery_results[gquery];
        new_height = Math.round(ratio / total_renewables_ratio * chart_max_height);
        this._animate_chart_item(code, new_height);
        this._update_legend_item(code, ratio);
      }
      $(".chart header span.total_amount").html(sprintf("%.1f", current_sum / 1000000000));
      return this.unblock_interface();
    };
    Chart.prototype._animate_chart_item = function(code, height) {
      var charts_to_be_updated, item;
      charts_to_be_updated = $(".charts_container").not('.static');
      item = charts_to_be_updated.find("ul.chart ." + code);
      return item.animate({
        "height": height
      }, "slow");
    };
    Chart.prototype._update_legend_item = function(code, ratio) {
      var percentage, selector;
      percentage = Math.round(ratio * 100);
      selector = $(".legend tr." + code + " td.value");
      return selector.html("" + percentage + "%");
    };
    Chart.prototype.update_etm_link = function(url) {
      return $("footer a.open_in_etm").click(__bind(function(e) {
        if (confirm(window.globals.open_in_etm_link)) {
          return $(e.target).attr("href", url);
        }
      }, this));
    };
    return Chart;
  })();
}).call(this);
