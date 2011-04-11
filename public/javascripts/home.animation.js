function Home() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.shares = {};
  
  // show cumulative data
  self.reset_carriers = function() {
    self.update_carriers('total', 1000);
  };
  
  self.update_carriers = function(key, speed) {
    if(typeof(speed) == "undefined") { speed = 350 }
    self._update_carriers(self.shares[key], speed);
  };
  
  self._update_carriers = function (carrier_values, speed) {
    $.each(carrier_values, function(carrier, value){
      
      var original_height = self.original_height[carrier];
      var new_height = value / self.shares["total"][carrier] * original_height;
      
      var carrier_li = $("ul.chart").find("." + carrier);
      carrier_li.stop(true);
      carrier_li.animate({"height": new_height}, speed);
      var label = carrier_li.find(".label");
      new_height > 11 ? label.show() : label.hide();
    });
  };
  
  self._save_original_height = function() {
    self.original_height = {
      coal:      $("ul.chart li.coal").height(),
      gas:       $("ul.chart li.gas").height(),
      oil:       $("ul.chart li.oil").height(),
      nuclear:   $("ul.chart li.nuclear").height(),
      renewable: $("ul.chart li.renewable").height()
    }
  };
  
  self.init = function() {
    self.shares = globals.carriers;
    self._save_original_height();
  };
  
  self.init();
}

$(document).ready(function(){
  h = new Home();
  
  $("#sectors .sector").hover(
    // handlerin
    function(){
      var sector_id = $(this).attr("id");
      h.update_carriers(sector_id);
    },
    // handlerout
    function(){
      h.reset_carriers();
    });
});
