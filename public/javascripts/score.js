/* DO NOT MODIFY. This file was compiled Wed, 21 Sep 2011 14:22:34 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/score.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  this.Score = (function() {
    function Score(app) {
      this.app = app;
      this.values = {
        mixer_co2_reduction_from_1990: {
          mark: null,
          current: null
        },
        mixer_renewability: {
          mark: null,
          current: null
        },
        mixer_bio_footprint: {
          mark: null,
          current: null
        },
        mixer_net_energy_import: {
          mark: null,
          current: null
        },
        total_amount: {
          mark: null,
          current: null
        }
      };
      this.setup_interface_callbacks();
    }
    Score.prototype.calculate = function() {
      var a, b, c, d, e, key, v, value, _ref;
      _ref = this.values;
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        value = _ref[key];
        if (value.mark === null || value.current === null) {
          return false;
        }
      }
      v = this.values.total_amount;
      a = (v.mark - v.current) / 1000;
      if (a < 0) {
        a = 0;
      }
      v = this.values.mixer_co2_reduction_from_1990;
      b = 0;
      if (v.mark > v.current) {
        b = Math.abs((v.mark - v.current) * 100);
      }
      v = this.values.mixer_renewability;
      c = (v.current - v.mark) * 100;
      if (c < 0) {
        c = 0;
      }
      v = this.values.mixer_bio_footprint;
      d = (v.mark - v.current) * 100;
      if (d < 0) {
        d = 0;
      }
      v = this.values.mixer_net_energy_import;
      e = (v.mark - v.current) * 100;
      if (e < 0) {
        e = 0;
      }
      $("#score .cost").html(sprintf("%.2f", a));
      $("#score .co2").html(sprintf("%.2f", b));
      $("#score .renewables").html(sprintf("%.2f", c));
      $("#score .areafp").html(sprintf("%.2f", d));
      $("#score .import").html(sprintf("%.2f", e));
      return a + b + c + d + e;
    };
    Score.prototype.show = function() {
      var current_question_dom_id, input_selector;
      this.score = this.calculate();
      if (this.score !== false && this.app.questions.current_question > 2) {
        $("#dashboard #score .value").html(parseInt(this.score));
        $("#dashboard #score").show();
        $("input#scenario_score").val(this.score);
        if (!this.should_show_score_explanation()) {
          $("#score .explanation").hide();
        }
        current_question_dom_id = this.app.questions.current_question - 1;
        input_selector = "#scenario_answers_attributes_" + current_question_dom_id + "_score";
        return $(input_selector).val(this.score);
      }
    };
    Score.prototype.setup_interface_callbacks = function() {
      return $("#score #show_info").click(__bind(function() {
        $("#score .details").toggle();
        if (this.should_show_score_explanation()) {
          return $("#score .explanation").show();
        } else {
          return $("#score .explanation").hide();
        }
      }, this));
    };
    Score.prototype.should_show_score_explanation = function() {
      return this.score === false && this.app.questions.current_question <= 2;
    };
    return Score;
  })();
}).call(this);
