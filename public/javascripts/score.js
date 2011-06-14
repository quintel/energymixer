function Score() {
  // Prevent calling the function without the new operator
  if ( !(this instanceof arguments.callee) ) {
    return new arguments.callee(arguments);
  }

  var self = this;
  
  self.values = {
    co2_emission_percent_change_from_1990_corrected_for_electricity_import : { mark : null, current : null},
    share_of_renewable_energy : { mark : null, current : null},
    area_footprint_per_nl : { mark : null, current : null},
    energy_dependence : { mark : null, current : null},
    total_amount : { mark : null, current : null}
  }
  
  self.calculate = function() {
    for (s in self.values) {
      var h = self.values[s];
      if (h.mark == null || h.current == null) return false;
    }
    
    var v = self.values.total_amount;
    var a = (v.mark - v.current) / v.mark * 100;
    if (a < 0) { a = 0; }
    
    v = self.values.co2_emission_percent_change_from_1990_corrected_for_electricity_import;
    var b = 0;
    if (v.mark > v.current) {
      b = Math.abs((v.mark - v.current) / v.mark * 100);
    }
    
    v = self.values.share_of_renewable_energy;
    var c = (v.current - v.mark) / v.mark * 100;
    if (c < 0) { c = 0; }    
    
    v = self.values.area_footprint_per_nl;
    var d = (v.mark - v.current) / v.mark * 100;
    if (d < 0) { d = 0; }
    
    v = self.values.energy_dependence;
    var e = (v.mark - v.current) / v.mark * 100;
    if (e < 0) { e = 0; }

    return a + b + c + d + e;
  }
  
}

score = new Score();
