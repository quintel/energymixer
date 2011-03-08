function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path  = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id = false;
  self.parameters = {};
    
  self.fetch_session_id = function() {
    if (self.session_id) {
      console.log("Using cached session key " + self.session_id);
      return self.session_id;
    }
    
    var url = self.base_path + "new.json"
    
    $.ajax({
      url: url,
      dataType: 'jsonp',
      success: function(data){
        var key = data.api_scenario.api_session_key;
        self.session_id = key;
        console.log("Fetched Session Key: " + key)
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
  
  self.get_results = function(res) {
    if(!res) res = ["co2_emission_total"]; //for testing
    var url = self.json_path_with_session_id();
    console.log(url);
    $.ajax({
      url: self.json_path_with_session_id(),
      data: { result: res },
      dataType: 'jsonp',
      success: function(data){
        console.log("Yeah!: Got results");
        console.log(data.result);
        self.results = data;
        $("#response").html(JSON.stringify(data));        
      },
      error: function(data){
        alert('an error occured');
        console.log(url);
      }
    });
    return self.results;
  };
  
  // will send the parameters and fetch results in a single step
  self.run = function(res) {
    self.process_form();
    if(!res) res = ["co2_emission_total"];
    var url = self.json_path_with_session_id();
    console.log(url);
    $.ajax({
      url: url,
      data: { result: res, input: self.parameters },
      dataType: 'jsonp',
      success: function(data){
        console.log("Got results");
        self.results = data;
        $("#response").html(JSON.stringify(data));        
      },
      error: function(){
        alert('an error occured');
      }
    });    
  };  

  self.push_parameters = function() {
    var url = self.base_path_with_session_id() + ".json";
    console.log(url);
    $.ajax({
      url: url,
      data: { input: self.parameters },
      dataType: 'jsonp',
      success: function(data){
        console.log("Pushed parameters");
      },
      error: function(){
        alert('an error occured');
      }
    });
  };
    
  // merges in the common hash
  self.set_parameter = function(key, value) {
    self.parameters[key] = value;
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

  self.update_results_section = function() {
    var res = $.map($(".output[gquery]"), function(container, index) {
      return $(container).attr("gquery");
    });

    $.ajax({
      url: self.base_path_with_session_id() + ".json",
      data: { result: res },
      dataType: 'jsonp',
      success: function(data){
        var results = data.result;
        $.each(results, function(parameter, result) {
          $('.output[gquery="' + parameter + '"]').html(result[1][1]);
        });
      },
      error: function(){
        alert('an error occured');
      }
    });
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}


$(function() {
  m = new Mixer();
  
  m.update_results_section();
  
  
  // interface
  $("form").submit(function() {
    m.run();
    return false;
  });
  
});
