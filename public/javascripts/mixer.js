// This objects handles the core mixer functionality.
// For the output it depends on the Graph object and it
// requires some parameters to be set in the globals hash,
// namely api_base_path and api_session_settings
function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path        = globals.api_base_path + "/api_scenarios";
  self.session_id       = false;
  self.scenario_id      = false;
  self.etm_scenario_url = false;
  self.parameters       = {}; // parameters set according to user answers
  self.results          = {}; // semiraw response from the engine
  self.user_answers     = []; // right from the form
  self.carriers_values  = {}; // used by graph, too!
  self.dashboard_values = {}; // idem
  self.secondary_carriers_values  = {};
  self.gquery_results   = {}; // clean results hash

  self.dashboard_items     = globals.dashboard_items; // provided by the controller
  self.mix_table           = globals.mix_table;       // idem
  self.secondary_mix_table = globals.secondary_mix_table;       // idem

  self.gqueries = self.mix_table.
    concat(self.dashboard_items).
    concat(self.secondary_mix_table).
    concat(["policy_total_energy_cost"]);

  self.fetch_session_id = function() {
    if (self.session_id) {
      return self.session_id;
    }
    $.ajax({
      url: self.base_path + "/new.json",
      dataType: 'jsonp',
      data: { settings : globals.api_session_settings },
      success: function(data){
        var key = data.api_scenario.api_session_key;
        self.session_id = self.scenario_id = key;
        self.etm_scenario_url = globals.etm_scenario_base_url + '/' + self.scenario_id + "/load?locale=nl";
        graph.update_etm_link();
        $.logThis("Fetched new session Key: " + key);
        // show data for the first time
        self.make_request();
      },
      error: function(request, status, error){
        $.logThis(error);
      }
    });
    return self.session_id;
  };
  
  self.base_path_with_session_id = function() {
    var url = self.base_path + "/" + self.fetch_session_id();
    return url;
  };
  
  self.json_path_with_session_id = function(){
    var url = self.base_path_with_session_id() + ".json";
    return url;
  };
      
  // saving results to local variables in human readable format
  // store data in hidden form inputs too
  self.store_results = function() {
    var results = self.results.result
    
    // let's store all values in the corresponding hidden inputs
    $.each(results, function(key, raw_results) {
      var value = raw_results[1][1];
      $("input[type=hidden][data-label="+key+"]").val(value);
      self.gquery_results[key] = value;
    });
    
    // total cost is used fairly often, let's save it in the mixer object
    self.total_cost = results["policy_total_energy_cost"][1][1]
    
    // now let's udpate the result collections
    $.each(self.mix_table, function(index, code){
      var value = Math.round(self.gquery_results[code]/1000000)
      self.carriers_values[code] = value;
    });

    $.each(self.secondary_mix_table, function(index, code){
      var value = Math.round(self.gquery_results[code]/1000000)
      self.secondary_carriers_values[code] = value;
    });

    $.each(self.dashboard_items, function(index, code){
      var value = self.gquery_results[code];
      self.dashboard_values[code] = value;
      
      // update scores object, which is based on dashboard values
      score.values[code].current = value;
      if (q.current_question == 2 && score.values[code].mark === null) {
        score.values[code].mark = value;
      }
    });
  };
  
  // sends the current parameters to the engine, stores
  // the results and triggers the interface update
  self.make_request = function(hash) {
    if(!hash) hash = self.parameters;
    var request_parameters = {result: self.gqueries, reset: 1};
    if(!$.isEmptyObject(hash)) request_parameters['input'] = hash;
    // Note that we're not using the standard jquery ajax call,
    // but http://code.google.com/p/jquery-jsonp/
    // for its better error handling.
    // http://stackoverflow.com/questions/1002367/jquery-ajax-jsonp-ignores-a-timeout-and-doesnt-fire-the-error-event
    // if we're going back to vanilla jquery change the callback parameters,
    // add type: json and remove the '?callback=?' url suffix
    graph.block_interface();    
    $.jsonp({      
      url: self.json_path_with_session_id() + '?callback=?',
      data: request_parameters,
      success: function(data){
        // if(data.errors.length > 0) { alert(data.errors); }
        self.results = data;
        self.store_results();
        graph.refresh();
        score.show();
      },
      error: function(data, error){
        graph.unblock_interface();
        $.logThis(error);
      }
    });
    return true;
  };
  
  self.set_parameter = function(id, value) {
    self.parameters[id] = value;
    return self.parameters;
  };
  
  // build parameters given user answers. The parameter values are defined in the
  // global answer hash.
  self.build_parameters = function() {
    self.parameters = {};
    $.each(self.user_answers, function(index, item){
      var question_id = item[0];
      var answer_id   = item[1];
      // globals.answers is defined on the view!
      $.each(globals.answers[question_id][answer_id], function(param_key, val) {
        self.set_parameter(param_key, val);
      });      
    });
  };
  
  // makes an array out of user answers in this format:
  // [ [question_1_id, answer_1_id], [question_2_id, answer_2_id], ...]
  self.process_form = function() {
    self.user_answers = [];
    $("div.question ul.answers input:checked").each(function(el) {
      var question_id = $(this).data('question_id');
      self.user_answers.push([question_id, parseInt($(this).val())]);
    });
    // $.logThis("User answers : " + $.toJSON(self.user_answers));
    self.build_parameters();
    // self.debug_parameters();
    return self.parameters;
  };

  self.debug_parameters = function() {
    $.logThis("Current parameters : " + $.toJSON(self.parameters));
  };
  
  // parses form, prepares parametes, makes ajax request and refreshes the graph
  // called every time the user selects an answer
  self.refresh = function() {
    self.process_form();
    self.make_request();
  };
    
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}