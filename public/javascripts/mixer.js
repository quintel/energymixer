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
  
  self.base_path        = globals.api_base_path;
  self.session_id       = false;
  self.scenario_id      = false;
  self.etm_scenario_url = false;
  self.parameters       = {}; // parameters set according to user answers
  self.results          = {}; // semiraw response from the engine
  self.user_answers     = []; // right from the form
  self.carriers_values  = {}; // used by graph, too!
  self.dashboard_values = {}; // idem
  self.secondary_carriers_values  = {};

  self.dashboard_items     = globals.dashboard_items; // provided by the controller
  self.mix_table           = globals.mix_table;       // idem
  self.secondary_mix_table = globals.secondary_mix_table;       // idem

  self.gqueries = self.mix_table.concat(self.dashboard_items).concat(self.secondary_mix_table);

  self.fetch_session_id = function() {
    if (self.session_id) {
      return self.session_id;
    }
    $.ajax({
      url: self.base_path + "new.json",
      dataType: 'jsonp',
      data: { settings : globals.api_session_settings },
      success: function(data){
        var key          = data.api_scenario.api_session_key;
        var scenario_id  = data.api_scenario.id;
        self.session_id  = key;
        self.scenario_id = scenario_id;
        self.etm_scenario_url = globals.etm_scenario_base_url + scenario_id + "/load?locale=nl";
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
    var url = self.base_path + self.fetch_session_id();
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
    $.each(self.mix_table, function(index, code){
      var raw_value = results[code][1][1];
      var value = Math.round(raw_value/1000000)
      self.carriers_values[code] = value;
      $("input[type=hidden][data-label="+code+"]").val(raw_value);
    });
    $.each(self.secondary_mix_table, function(index, code){
      var raw_value = results[code][1][1];
      var value = Math.round(raw_value/1000000)
      self.secondary_carriers_values[code] = value;
      $("input[type=hidden][data-label="+code+"]").val(raw_value);
    });
    $.each(self.dashboard_items, function(index, code){
      var value = results[code][1][1];
      self.dashboard_values[code] = value;
      $("input[type=hidden][data-label="+code+"]").val(value);
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
        // $.logThis("Got results : " + $.toJSON(data));
        // TODO: remove this when live
        if(data.errors.length > 0) { alert(data.errors); }
        self.results = data;
        self.store_results();
        graph.refresh();
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
    $.logThis("User answers : " + $.toJSON(self.user_answers));
    self.build_parameters();
    self.debug_parameters();
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