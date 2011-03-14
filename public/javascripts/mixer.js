function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path    = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id   = false;
  self.parameters   = {};
  self.results      = {};
  self.user_answers = {};
  self.carriers_values  = {};
  self.dashboard_values = {};
  
  //TODO: get them dynamically from the database? Or even load them in environment, so one query per start-up of the server. DS
  self.mix_table = ["total_cost_of_primary_coal",
                  "total_cost_of_primary_natural_gas",
                  "total_cost_of_primary_oil",
                  "total_cost_of_primary_nuclear",
                  "total_cost_of_primary_renewable"];

  self.dashboard = ["co2_emission",
                  "share_of_renewable_energy",
                  "area_footprint_per_nl",
                  "energy_dependence"];

  self.gqueries = self.mix_table.concat(self.dashboard);

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
      error: function(){
        alert('an error occured');
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
  
  // assumes results have been stored  
  self.display_results = function() {
    var results = self.results.result
    $.each(self.carriers_values, function(key, value){
      $("#" + key).html(value);
    });
    $.each(self.dashboard_values, function(key, value){
      $("#" + key).html(value);
    });
    console.log("Updated results section");    
  };
  
  // saving results to local variables in human readable format
  self.store_results = function() {
    var results = self.results.result    
    $.each(self.mix_table, function(index, code){
      // TODO: refactor
      var value = Math.round(results[code][1][1]/1000000)
      self.carriers_values[code] = value;
    });
    $.each(self.dashboard, function(index, code){
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
    $.ajax({
      url: self.json_path_with_session_id(),
      data: request_parameters,
      dataType: 'jsonp',
      success: function(data){
        console.log("Got results:" + $.toJSON(data.result));
        self.results = data;
        self.store_results();
        self.display_results();
        self.unblock_interface();
      },
      error: function(){
        self.unblock_interface();
        alert('an error occured');
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
      // console.log("Processing question #" + question_id);
      $.each(answers[question_id][answer_id], function(param_key, val) {
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
    self.block_interface();
    self.process_form();
    self.make_request();
    // the interface is released in the make_request method
  };
  
  self.block_interface = function() {
    $("#results").fadeTo(1, 0.25);
    $(".answers input:radio").attr('disabled', true);
  };
  
  self.unblock_interface = function() {
    $("#results").fadeTo(1, 1);
    $(".answers input:radio").attr('disabled', false);
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}