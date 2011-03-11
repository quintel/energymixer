function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path  = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id = false;
  self.parameters = {};
  self.results={};
  
  //TODO: get them dynamically from the database? Or even load them in environment, so one query per start-up of the server. DS
  self.gqueries = ["total_cost_of_primary_coal",
                  "total_cost_of_primary_natural_gas",
                  "total_cost_of_primary_oil",
                  "total_cost_of_primary_nuclear",
                  "total_cost_of_primary_renewable",                  
                  "co2_emission",
                  "share_of_renewable_energy",
                  "area_footprint_per_nl",
                  "energy_dependence"];

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
    
  self.display_results = function() {
    var results = self.results.result
    for (gquery in results){
      $("#"+gquery).html(Math.round(results[gquery][1][1]/1000000));
    }
    console.log("Updated results section");    
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
        self.display_results();
      },
      error: function(){
        alert('an error occured');
      }
    });
    return true;
  };
  
  self.set_parameter = function(id, value) {
    self.parameters[id] = value;
    return self.parameters;
  };
  
  // fills the parameters hash (to be sent by ajax to the engine) with the values
  // corresponding to the selected answers
  self.process_form = function() {
    console.log("Processing form elements");
    self.parameters = {};
    $("div.question").each(function(el) {
      var question_name = $(this).attr('id');
      var field_selector = "input[name=" + question_name + "]:checked";
      var selected_option = $(field_selector).val();
      if (!selected_option) return;
      var selected_option_label = "answer_" + selected_option;
      $.each(answers[question_name][selected_option_label], function(param_key, val) {
        self.set_parameter(param_key, val);
      });
    });

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
	  self.debug_parameters();
	  self.make_request();
	  self.unblock_interface();
	};
	
  self.block_interface = function() {
    $("#results table").fadeTo(1, 0.2);
    $(".answers input:radio").attr('disabled', true);
  };
  
  self.unblock_interface = function() {
    $("#results table").fadeTo(1, 1);
    $(".answers input:radio").attr('disabled', false);
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}