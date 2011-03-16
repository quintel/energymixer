function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path    = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id   = false;
  self.parameters   = {}; // parameters set according to user answers
  self.results      = {}; // semiraw response from the engine
  self.user_answers = {}; // right from the form
  self.carriers_values  = {}; // used by graph, too!
  self.dashboard_values = {}; // idem

  self.dashboard_items = globals.dashboard_items; // provided by the controller
  self.mix_table       = globals.mix_table;       // idem

  self.gqueries = self.mix_table.concat(self.dashboard_items);

  self.fetch_session_id = function() {
    if (self.session_id) {
      return self.session_id;
    }
    $.ajax({
      url: self.base_path + "new.json",
      dataType: 'jsonp',
      success: function(data){
        var key = data.api_scenario.api_session_key;
        self.session_id = key;
        console.log("Fetched new session Key: " + key);
        // show data for the first time
        self.make_request();
      },
      error: function(request, status, error){
        console.log(error);
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
  self.store_results = function() {
    var results = self.results.result    
    $.each(self.mix_table, function(index, code){
      // TODO: refactor
      var value = Math.round(results[code][1][1]/1000000)
      self.carriers_values[code] = value;
    });
    $.each(self.dashboard_items, function(index, code){
      var value = results[code][1][1];
      self.dashboard_values[code] = value;
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
        console.log("Got results:" + $.toJSON(data.result));
        self.results = data;
        self.store_results();
        graph.refresh();
      },
      error: function(data, error){
        graph.unblock_interface();
        console.log(error);
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
    $.each(self.user_answers, function(question_id, answer_id){
      // globals.answers is defined on the view!
      $.each(globals.answers[question_id][answer_id], function(param_key, val) {
        self.set_parameter(param_key, val);
      });      
    });
  };
  
  // makes a hash out of user answers in this format:
  // { question_1_id : answer_1_id, question_2_id : answer_2_id }
  self.process_form = function() {
    self.user_answers = {};
    $("div.question input:checked").each(function(el) {
      var question_id = $(this).attr('data-question_id');
      self.user_answers[question_id] = $(this).val();
    });
    console.log("User answers:" + $.toJSON(self.user_answers));
    self.build_parameters();
    self.debug_parameters();
    return self.parameters;
  };

  self.debug_parameters = function() {
    console.log($.toJSON(self.parameters));
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