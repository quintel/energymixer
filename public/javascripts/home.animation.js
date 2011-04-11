$(document).ready(function(){
  
  var shares = {
    industry: {
      coal: .50,
      gas: .50,
      oil: .50,
      nuclear: .50,
      renewable: .50,
      money: .50
    },
    transport: {
      coal: .15,
      gas: .10,
      oil: .20,
      nuclear: .50,
      renewable: .5
    },
    buildings: {
      coal: .15,
      gas: .10,
      oil: .20,
      nuclear: .50,
      renewable: .5
    },
    agriculture: {
      coal: .15,
      gas: .10,
      oil: .20,
      nuclear: .50,
      renewable: .5
    }
  };
  
  function update_carriers (carrier_values) {
    $.each(carrier_values, function(carrier, value){
      var carrier_li = $("ul.chart").find("."+carrier);
      var current_height = carrier_li.height();
      carrier_li.animate({"height": current_height * value}, 2000);
    });
  };
  
  update_carriers(shares.industry);
    
  // var new_height = Math.round(val / current_sum * current_graph_height);
  // rounded_sum += new_height;
  // var selector = ".user_created ." + code;
  // $(selector).animate({"height": new_height}, "slow");
  // // hide text if there's no room
  // var label = $(selector + " .label");
  // new_height > 10 ? label.show() : label.hide();  
  
});