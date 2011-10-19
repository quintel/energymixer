/* DO NOT MODIFY. This file was compiled Thu, 13 Oct 2011 10:21:13 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/score_board.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  this.ScoreBoard = (function() {
    __extends(ScoreBoard, Backbone.View);
    function ScoreBoard() {
      this.toggle_score = __bind(this.toggle_score, this);
      ScoreBoard.__super__.constructor.apply(this, arguments);
    }
    ScoreBoard.prototype.initialize = function() {
      this.score = false;
      return this.values = {
        mixer_reduction_of_co2_emissions_versus_1990: {
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
        mixer_total_costs: {
          mark: null,
          current: null
        }
      };
    };
    ScoreBoard.prototype.el = 'body';
    ScoreBoard.prototype.events = {
      "click #score": "toggle_score"
    };
    ScoreBoard.prototype.update_values = function(gqueries) {
      var key, v, values, _ref, _results;
      _ref = this.values;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        values = _ref[key];
        v = gqueries[key];
        values.current = v;
        _results.push(this.model.questions.current_question === 2 ? values.mark = v : void 0);
      }
      return _results;
    };
    ScoreBoard.prototype.co2_score = function() {
      var score, v;
      v = this.values.mixer_reduction_of_co2_emissions_versus_1990;
      score = 0;
      if (v.mark > v.current) {
        score = Math.abs((v.mark - v.current) * 100);
      }
      return score;
    };
    ScoreBoard.prototype.renewability_score = function() {
      var score, v;
      v = this.values.mixer_renewability;
      score = (v.current - v.mark) * 100;
      if (score < 0) {
        score = 0;
      }
      return score;
    };
    ScoreBoard.prototype.costs_score = function() {
      var score, v;
      v = this.values.mixer_total_costs;
      score = (v.mark - v.current) / 100000000;
      if (score < 0) {
        score = 0;
      }
      return score;
    };
    ScoreBoard.prototype.footprint_score = function() {
      var score, v;
      v = this.values.mixer_bio_footprint;
      score = (v.mark - v.current) * 100;
      if (score < 0) {
        score = 0;
      }
      return score;
    };
    ScoreBoard.prototype.dependence_score = function() {
      var score, v;
      v = this.values.mixer_net_energy_import;
      score = (v.mark - v.current) * 100;
      if (score < 0) {
        score = 0;
      }
      return score;
    };
    ScoreBoard.prototype.total_score = function() {
      return this.co2_score() + this.renewability_score() + this.costs_score() + this.footprint_score() + this.dependence_score();
    };
    ScoreBoard.prototype.render = function() {
      var current_question_dom_id, input_selector, key, value, _ref;
      _ref = this.values;
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        value = _ref[key];
        if (value.mark === null || value.current === null) {
          return false;
        }
      }
      this.score = parseInt(this.total_score());
      $(".score_details table .cost").html(sprintf("%.2f", this.costs_score()));
      $(".score_details table .co2").html(sprintf("%.2f", this.co2_score()));
      $(".score_details table .renewables").html(sprintf("%.2f", this.renewability_score()));
      $(".score_details table .areafp").html(sprintf("%.2f", this.footprint_score()));
      $(".score_details table .import").html(sprintf("%.2f", this.dependence_score()));
      $("#score .value").html(this.score);
      $("input#scenario_score").val(this.score);
      if (!this.should_show_score_explanation()) {
        $(".score_details .explanation").hide();
      }
      current_question_dom_id = this.model.questions.current_question - 1;
      input_selector = "#scenario_answers_attributes_" + current_question_dom_id + "_score";
      return $(input_selector).val(this.score);
    };
    ScoreBoard.prototype.toggle_score = function(e) {
      var explanation;
      $(".score_details").toggle();
      explanation = $(e.target).find(".explanation");
      if (this.should_show_score_explanation()) {
        return explanation.show();
      } else {
        return explanation.hide();
      }
    };
    ScoreBoard.prototype.should_show_score_explanation = function() {
      return this.score === false && this.model.questions.current_question <= 2;
    };
    return ScoreBoard;
  })();
}).call(this);