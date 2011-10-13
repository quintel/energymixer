/* DO NOT MODIFY. This file was compiled Thu, 13 Oct 2011 14:25:41 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/mixer.coffee
 */

(function() {
  var Mixer;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Mixer = (function() {
    __extends(Mixer, Backbone.Model);
    function Mixer() {
      Mixer.__super__.constructor.apply(this, arguments);
    }
    Mixer.prototype.initialize = function() {
      this.chart = new Chart({
        model: this
      });
      this.questions = new Questions({
        model: this
      });
      this.score = new ScoreBoard({
        model: this
      });
      this.gqueries = window.globals.gqueries;
      this.base_path = globals.api.base_path + "/api_scenarios";
      this.scenario_id = false;
      this.parameters = {};
      this.user_answers = [];
      this.gquery_results = {};
      this.score_enabled = globals.config.score_enabled;
      return this.fetch_scenario_id();
    };
    Mixer.prototype.fetch_scenario_id = function() {
      if (this.scenario_id) {
        return this.scenario_id;
      }
      $.ajax({
        url: "" + this.base_path + "/new.json",
        dataType: 'jsonp',
        data: {
          settings: globals.api.session_settings
        },
        success: __bind(function(data) {
          var key;
          key = data.api_scenario.id || data.api_scenario.api_session_key;
          this.scenario_id = key;
          this.chart.update_etm_link("" + globals.api.load_in_etm_url + "/" + this.scenario_id + "/load?locale=nl");
          $.logThis("New scenario id: " + key);
          return this.make_request();
        }, this),
        error: function(request, status, error) {
          return $.logThis(error);
        }
      });
      return this.scenario_id;
    };
    Mixer.prototype.store_results = function(results) {
      var key, raw_results, value;
      for (key in results) {
        if (!__hasProp.call(results, key)) continue;
        raw_results = results[key];
        value = raw_results[1][1];
        this.gquery_results[key] = value;
        $("input[type=hidden][data-label=" + key + "]").val(value);
      }
      return this.score.update_values(this.gquery_results);
    };
    Mixer.prototype.all_gqueries = function() {
      var key, _i, _len, _ref;
      if (this._all_gqueries) {
        return this._all_gqueries;
      }
      this._all_gqueries = [];
      _ref = ['primary', 'secondary', 'dashboard', 'costs'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        this._all_gqueries = this._all_gqueries.concat(_.values(this.gqueries[key]));
      }
      return this._all_gqueries;
    };
    Mixer.prototype.make_request = function() {
      var api_url, request_parameters;
      request_parameters = {
        result: this.all_gqueries(),
        reset: 1
      };
      if (!$.isEmptyObject(this.parameters)) {
        request_parameters['input'] = this.parameters;
      }
      api_url = "" + this.base_path + "/" + (this.fetch_scenario_id()) + ".json?callback=?";
      this.chart.block_interface();
      $.jsonp({
        url: api_url,
        data: request_parameters,
        success: __bind(function(data) {
          this.store_results(data.result);
          this.chart.render();
          return this.score.render();
        }, this),
        error: __bind(function(data, error) {
          this.chart.unblock_interface();
          return $.logThis(error);
        }, this)
      });
      return true;
    };
    Mixer.prototype.build_parameters = function() {
      var answer_id, index, item, param_key, question_id, val, _ref, _results;
      this.parameters = {};
      _ref = this.user_answers;
      _results = [];
      for (index in _ref) {
        if (!__hasProp.call(_ref, index)) continue;
        item = _ref[index];
        question_id = item[0];
        answer_id = item[1];
        _results.push((function() {
          var _ref2, _results2;
          _ref2 = globals.answers[question_id][answer_id];
          _results2 = [];
          for (param_key in _ref2) {
            if (!__hasProp.call(_ref2, param_key)) continue;
            val = _ref2[param_key];
            _results2.push(this.parameters[param_key] = val);
          }
          return _results2;
        }).call(this));
      }
      return _results;
    };
    Mixer.prototype.process_form = function() {
      var elem, obj, question_id, _i, _len, _ref;
      this.user_answers = [];
      _ref = $("div.question ul.answers input:checked");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        elem = _ref[_i];
        obj = $(elem);
        question_id = obj.data('question_id');
        this.user_answers.push([question_id, parseInt(obj.val())]);
      }
      this.build_parameters();
      return this.parameters;
    };
    Mixer.prototype.refresh = function() {
      this.process_form();
      return this.make_request();
    };
    return Mixer;
  })();
  $(function() {
    return window.app = new Mixer;
  });
}).call(this);
