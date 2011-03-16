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

  self.dashboard = globals.dashboard_items;
  self.mix_table = globals.mix_table;

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
  
  // assumes results have been stored  
  self.display_results = function() {
    // update carriers table
    $.each(self.carriers_values, function(key, value){
      $("#carriers ." + key).html(value);
    });
    $.each(self.dashboard_values, function(key, value){
      var formatted_value = self.format_dashboard_value(key, value);
      $("#dashboard ." + key).html(formatted_value);
    });
    self.update_graph();
  };
  
  // it would be nice to define these formats in the controller but the
  // code would become a nightmare
  // TODO: check whether the output values are right!!
  self.format_dashboard_value = function(key, value) {
    var out = "";
    switch(key) {
      case "co2_emission":
        if (value > 0) out = "+";
        out += sprintf("%.1f", value) + "%";
        break;
      case "area_footprint_per_nl":
        out = sprintf("%.2f", value) + "xNL";
        break;
      case "share_of_renewable_energy":
      case "energy_dependence":
        out = sprintf("%.1f", value * 100) + "%";
        break;
      default:
        out = value;
    }
    return out;
  };
  
  self.update_graph = function() {
    var current_sum = 0.0;
    $.each(self.carriers_values, function(code, val) { current_sum += val });

    var graph_max_height = 320;
    var max_amount       = 80000; // million euros
    var current_graph_height = current_sum / max_amount * graph_max_height;
    $.each(self.carriers_values, function(code, val) {
      var new_height = val / current_sum * current_graph_height;
      var selector = "#graph ." + code;
      $(selector).animate({"height": new_height}, "slow");
      // hide text if there's no room
      var label = $(selector + " span");
      new_height > 5 ? label.show() : label.hide();
    });
    // update money column
    var new_money_height = current_graph_height + 4 * 2; // margin..
    $(".coins").animate({"height" : new_money_height}, "slow");
    
    // and top counter
    $("#total_amount span").html(current_sum / 1000);
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
    // Note that we're not using the standard jquery ajax call,
    // but http://code.google.com/p/jquery-jsonp/
    // for its better error handling.
    // http://stackoverflow.com/questions/1002367/jquery-ajax-jsonp-ignores-a-timeout-and-doesnt-fire-the-error-event
    // if we're going back to vanilla jquery change the callback parameters,
    // add type: json and remove the '?callback=?' url suffix
    $.jsonp({      
      url: self.json_path_with_session_id() + '?callback=?',
      data: request_parameters,
      success: function(data){
        console.log("Got results:" + $.toJSON(data.result));
        self.results = data;
        self.store_results();
        self.display_results();
        self.unblock_interface();
      },
      error: function(data, error){
        self.unblock_interface();
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
    self.block_interface();
    self.process_form();
    self.make_request();
    // the interface is released in the make_request method
  };
  
  self.block_interface = function() {
    $("#results .dashboard").fadeTo(1, 0.25);
    $(".answers input:radio").attr('disabled', true);
  };
  
  self.unblock_interface = function() {
    $("#results .dashboard").fadeTo(1, 1);
    $(".answers input:radio").attr('disabled', false);
  };
  
  self.init = function() {
    self.fetch_session_id();
  };
  
  self.init();
}