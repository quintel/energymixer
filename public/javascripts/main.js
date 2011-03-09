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
  self.gqueries= ["total_cost_of_primary_coal",
                  "total_cost_of_primary_natural_gas",
                  "total_cost_of_primary_oil",
                  "total_cost_of_primary_nuclear",
                  "total_cost_of_primary_renewable",
                  
                  "co2_emission",
                  "share_of_renewable_energy",
                  "area_footprint_per_nl",
                  "energy_dependence"
                  ];

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
        console.log("Fetched new session Key: " + key)
        //this has to be here, since we have to wait for the session id.
        self.get_results();
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
    
  self.get_results = function() {
    $.ajax({
      url: self.json_path_with_session_id(),
      data: { result: self.gqueries },
      dataType: 'jsonp',
      success: function(data){
        //console.log("Got results");
        //console.log(data.result);
        self.results = data;
        self.update_results_section();
      },
      error: function(data){
        alert('an error occured');
      }
    });
    return self.results;
  };
  
  self.update_results_section = function() {
    var results = self.results.result
    for (gquery in results){
      //console.log(gquery + ": " + results[gquery][1][1]);
      $("#"+gquery).html(results[gquery][1][1]);
    }
  };
  
  self.push_inputs = function(hash) {
    $.ajax({
      url: self.json_path_with_session_id(),
      data: { input: hash },
      dataType: 'jsonp',
      success: function(data){
        self.results = data;
        console.log("Updated self.results");
        self.update_results_section();
        console.log("Updated results section");
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
  
  self.process_form = function() {
    console.log("Processing form elements");
    
    $.each(["q1"], function(index, question_name) {
      var field_selector = "input[name=" + question_name + "]:checked";
      var selected_option = $(field_selector).val();
      if (!selected_option) return;
      $.each(self.property_matrix[question_name][selected_option], function(param_key, val) {
        var param_id = self.property_map[param_key];
        self.parameters[param_id] = val;
      });
    });

    return self.parameters;
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}