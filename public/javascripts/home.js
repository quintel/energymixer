function Mixer() {
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;

  self.base_path  = "http://testing.et-model.com/api/v1/api_scenarios/";
  self.session_id = false;
  self.session_settings = {};

  self.inputs = {};
  self.outputs = [];

  self.fetch_session_id = function() {
    if (self.session_id) { return self.session_id }

    var url = self.base_path + "new.json";

    $.ajax({
      url: url,
      data: { settings: self.session_settings },
      dataType: "jsonp",
      success: function(data) { self.session_id = data.api_scenario.api_session_key },
      error: function() { alert("an error occured") }
    });

    return self.session_id
  };

  self.base_path_with_session_id = function() {
    return self.base_path + self.fetch_session_id()
  };

  self.json_path_with_session_id = function(){
    return self.base_path_with_session_id() + ".json"
  };

  self.set_input = function(input, value) {
    self.inputs[input] = value;
    return self.inputs
  };

  self.set_output = function(result) {
    self.outputs.push(result);
    return self.outputs
  };

  self.parameters = function() {
    var parameters = {};

    if(!$.isEmptyObject(self.inputs)) parameters.input = self.inputs;
    if(self.outputs.length > 0) parameters.result = self.outputs;

    return parameters
  };

  self.refresh = function(success_callback) {
    $.ajax({
      url: self.json_path_with_session_id(),
      data: self.parameters(),
      dataType: "jsonp",
      success: function(data) {
        var response = data.result;
        success_callback(response);
      },
      error: function() { alert("an error occured") }
    })
  };

  self.new_session = function() {
    self.fetch_session_id();
  };
}
