/* DO NOT MODIFY. This file was compiled Fri, 23 Sep 2011 09:59:49 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/mixer.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty;
  this.Mixer = (function() {
    function Mixer(app) {
      this.app = app;
      this.base_path = globals.api_base_path + "/api_scenarios";
      this.scenario_id = false;
      this.parameters = {};
      this.results = {};
      this.user_answers = [];
      this.carriers_values = {};
      this.dashboard_values = {};
      this.secondary_carriers_values = {};
      this.gquery_results = {};
      this.dashboard_items = globals.dashboard_items;
      this.mix_table = globals.mix_table;
      this.secondary_mix_table = globals.secondary_mix_table;
      this.gqueries = this.mix_table.concat(this.dashboard_items).concat(this.secondary_mix_table).concat(["mixer_total_costs"]);
      this.fetch_scenario_id();
    }
    Mixer.prototype.fetch_scenario_id = function() {
      if (this.scenario_id) {
        return this.scenario_id;
      }
      $.ajax({
        url: "" + this.base_path + "/new.json",
        dataType: 'jsonp',
        data: {
          settings: globals.api_session_settings
        },
        success: __bind(function(data) {
          var key;
          key = data.api_scenario.id || data.api_scenario.api_session_key;
          this.scenario_id = key;
          this.app.chart.update_etm_link("" + globals.etm_scenario_base_url + "/" + this.scenario_id + "/load?locale=nl");
          $.logThis("New scenario id: " + key);
          return this.make_request();
        }, this),
        error: function(request, status, error) {
          return $.logThis(error);
        }
      });
      return this.scenario_id;
    };
    Mixer.prototype.store_results = function() {
      var code, index, key, raw_results, results, value, _ref, _ref2, _ref3, _results;
      results = this.results.result;
      for (key in results) {
        if (!__hasProp.call(results, key)) continue;
        raw_results = results[key];
        value = raw_results[1][1];
        $("input[type=hidden][data-label=" + key + "]").val(value);
        this.gquery_results[key] = value;
      }
      this.total_cost = results["mixer_total_costs"][1][1];
      _ref = this.mix_table;
      for (index in _ref) {
        if (!__hasProp.call(_ref, index)) continue;
        code = _ref[index];
        this.carriers_values[code] = this.gquery_results[code];
      }
      _ref2 = this.secondary_mix_table;
      for (index in _ref2) {
        if (!__hasProp.call(_ref2, index)) continue;
        code = _ref2[index];
        this.secondary_carriers_values[code] = this.gquery_results[code];
      }
      _ref3 = this.dashboard_items;
      _results = [];
      for (index in _ref3) {
        if (!__hasProp.call(_ref3, index)) continue;
        code = _ref3[index];
        value = this.gquery_results[code];
        this.dashboard_values[code] = value;
        this.app.score.values[code].current = value;
        _results.push(this.app.questions.current_question === 2 && this.app.score.values[code].mark === null ? this.app.score.values[code].mark = value : void 0);
      }
      return _results;
    };
    Mixer.prototype.make_request = function() {
      var api_url, request_parameters;
      request_parameters = {
        result: this.gqueries,
        reset: 1
      };
      if (!$.isEmptyObject(this.parameters)) {
        request_parameters['input'] = this.parameters;
      }
      api_url = "" + this.base_path + "/" + (this.fetch_scenario_id()) + ".json?callback=?";
      this.app.chart.block_interface();
      $.jsonp({
        url: api_url,
        data: request_parameters,
        success: __bind(function(data) {
          this.results = data;
          this.store_results();
          this.app.chart.refresh();
          return this.app.score.refresh();
        }, this),
        error: function(data, error) {
          this.app.chart.unblock_interface();
          return $.logThis(error);
        }
      });
      return true;
    };
    Mixer.prototype.set_parameter = function(id, value) {
      this.parameters[id] = value;
      return this.parameters;
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
            _results2.push(this.set_parameter(param_key, val));
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
}).call(this);
