function Graph() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  // assumes results have been stored  
  self.refresh = function() {
    // update carriers table
    $.each(mixer.carriers_values, function(key, value){
      $("#carriers ." + key).html(value);
    });
    $.each(mixer.dashboard_values, function(key, value){
      var formatted_value = self.format_dashboard_value(key, value);
      console.log("setting image!");
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
      case "co2_emission_final_demand_to_1990_in_percent":
        if (value > 0) out = "+";
        out += sprintf("%.1f", value * 100) + "%";
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
    $.each(mixer.carriers_values, function(code, val) { current_sum += val });

    var graph_max_height = 320;
    var max_amount       = 80000; // million euros
    var current_graph_height = current_sum / max_amount * graph_max_height;
    $.each(mixer.carriers_values, function(code, val) {
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
    
    self.unblock_interface();
  };
          
  self.block_interface = function() {
    $("#dashboard .item .value, #total_amount, #carriers").busy({img: '/images/spinner.gif'});
  };
  
  self.unblock_interface = function() {
    $("#dashboard .item .value, #total_amount, #carriers").busy("clear");
  };
  
  self.setup_callbacks = function() {
    $("#solid_view").click(function(){
      $("#graph").removeClass("cilinder").addClass("solid");
    });

    $("#3d_view").click(function(){
      $("#graph").removeClass("solid").addClass("cilinder");
    });
  }; 
  
  self.init = function() {
    self.setup_callbacks();
  };
  
  self.init();
}