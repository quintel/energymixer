function Graph() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.dashboard_steps = globals.dashboard_steps;
  
  // Main entry point.
  // assumes results have been stored
  self.refresh = function() {
    // dashboard items
    $.each(mixer.dashboard_values, function(key, value){
      self.update_dashboard_item(key, value);
    });
    // colourful animated bar
    self.update_bar_chart();
  };
  
  self.block_interface = function() {
    $("#dashboard .dashboard_item .value, #graph_container .total_amount, #carriers").busy({img: '/images/spinner.gif'});
  };
  
  self.unblock_interface = function() {
    $("#dashboard .dashboard_item .value, #graph_container .total_amount, #carriers").busy("clear");
  };
    
  // the following methods should not be called directly
  // You might only have to update the format_dashboard_value method
  self.update_dashboard_item = function(key, value) {
    var dashboard_selector = "#dashboard ." + key;
    var formatted_value = self.format_dashboard_value(key, value);
    $(dashboard_selector + " .value").html(formatted_value);
    // we have now to decide which image to show as background
    // let's first find the right step
    var step = self.find_step_for_dashboard_item(key, value);
    // since we're doing everything through css classes, let's remove
    // the existing background-related classes
    var classes_to_remove = ''; // FIXME: ugly
    for(var i = 0; i < 10; i++) { classes_to_remove += key +"_step_" + i + " "}
    var class_to_add = key + "_step_" + step;
    $(dashboard_selector).removeClass(classes_to_remove).addClass(class_to_add);
  };
  
  self.find_step_for_dashboard_item = function(key, value) {
    // see DashboardItem#corresponding_step
    var steps = self.dashboard_steps[key];
    var step = 0;
    for(i in steps) {
      if(value > steps[i]) step = parseInt(i) + 1;
    }
    return step;
  };
  
  // it would be nice to define these formats in the controller but the
  // code would become a nightmare
  // TODO: check whether the output values are right!!
  // This formatter has a ruby equivalent as a view helper
  self.format_dashboard_value = function(key, value) {
    var out = "";
    switch(key) {
      // TODO: check format of this gquery
      case "co2_emission_final_demand_to_1990_in_percent":
        value *= -1;
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
  
  self.update_bar_chart = function() {
    var current_sum = 0.0;
    $.each(mixer.carriers_values, function(code, val) { current_sum += val });

    var graph_max_height = 320;
    var max_amount       = globals.graph_max_amount / 1000000; // million euros
    var current_graph_height = current_sum / max_amount * graph_max_height;
    $.each(mixer.carriers_values, function(code, val) {
      var new_height = val / current_sum * current_graph_height;
      var selector = "#graph_container ." + code;
      $(selector).animate({"height": new_height}, "slow");
      // hide text if there's no room
      var label = $(selector + " .label");
      new_height > 5 ? label.show() : label.hide();
    });
    // update money column
    var new_money_height = current_graph_height + 4 * 2; // margin..
    $(".coins").animate({"height" : new_money_height}, "slow");
    
    // and top counter
    $("#graph_container .total_amount span").html(current_sum / 1000);
    
    self.unblock_interface();
  };
            
  self.setup_callbacks = function() {
    $("#solid_view").click(function(){
      $(".carriers .graph").removeClass("textured").addClass("solid");
    });

    $("#3d_view").click(function(){
      $(".carriers .graph").removeClass("solid").addClass("textured");
    });
  }; 
  
  self.init = function() {
    self.setup_callbacks();
  };
  
  self.init();
}