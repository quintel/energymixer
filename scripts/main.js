function Mixer() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.base_path  = "http://testing.et-model.com/api/v1/api_scenarios";
  self.session_id = false;
  self.parameters  = {};
    
  self.fetch_session_id = function() {
    if (self.session_id) {
      console.log("Using cached session key " + self.session_id);
      return self.session_id;
    }
    
    var url = self.base_path + "/new.json"
    
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
    var url = self.base_path + self.fetch_session_id;
    return url;
  };

  // merges in the common hash
  self.set_parameter = function(key, value) {
    self.parameters[key] = value;
    return self.parameters;
  };
  
  self.init = function() {
    self.fetch_session_id();
  }
  
  self.init();
}



$(function() {
  m = new Mixer();
});
