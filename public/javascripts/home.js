/* DO NOT MODIFY. This file was compiled Wed, 21 Sep 2011 15:48:53 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/home.coffee
 */

(function() {
  var Home;
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Home = (function() {
    function Home() {
      this.shares = globals.carriers;
      this._save_original_height();
      this.setup_callbacks();
    }
    Home.prototype._save_original_height = function() {
      return this.original_height = {
        coal: $("ul.chart li.coal").height(),
        gas: $("ul.chart li.gas").height(),
        oil: $("ul.chart li.oil").height(),
        nuclear: $("ul.chart li.nuclear").height(),
        renewable: $("ul.chart li.renewable").height()
      };
    };
    Home.prototype._set_price = function(x) {
      var formatted_amount;
      formatted_amount = sprintf("%.1f", x / 1000000000);
      return $("#chart header span.amount").html(formatted_amount);
    };
    Home.prototype.update_price = function() {
      var amount;
      amount = this.shares.sectors[this.current_sector].total * this.shares.total.amount;
      return this._set_price(amount);
    };
    Home.prototype.update_chart = function() {
      var carrier, carrier_li, new_height, ratio, _ref, _results;
      _ref = this.shares.sectors[this.current_sector].carriers;
      _results = [];
      for (carrier in _ref) {
        if (!__hasProp.call(_ref, carrier)) continue;
        ratio = _ref[carrier];
        console.log("" + carrier + ": " + ratio);
        new_height = this.original_height[this.current_sector] * ratio / 1;
        carrier_li = $("ul.chart").find("." + carrier);
        _results.push(carrier_li.stop(true).animate({
          "height": new_height
        }, 500));
      }
      return _results;
    };
    Home.prototype.reset_map = function() {
      this.current_sector = null;
      return this._set_price(this.shares.total.amount);
    };
    Home.prototype.update_map = function() {
      this.update_price();
      return this.update_chart();
    };
    Home.prototype.setup_callbacks = function() {
      $("#sector_links .sector").hover(__bind(function(e) {
        var sector_id;
        sector_id = $(e.target).parent().attr("id");
        this.current_sector = sector_id;
        return this.update_map();
      }, this), __bind(function() {
        return this.reset_map();
      }, this));
      $("#sector_icons .sector").hover(__bind(function(e) {
        var sector_id;
        $(e.target).find(".popup").show();
        sector_id = $(e.target).attr("id");
        this.current_sector = sector_id;
        return this.update_map();
      }, this), __bind(function(e) {
        $(".popup").hide();
        return this.reset_map();
      }, this));
      return $("#sector_icons a").click(function(e) {
        var container;
        e.preventDefault();
        container = $(this).parent();
        container.find(".text").toggle();
        return $(this).toggleClass("close_description");
      });
    };
    return Home;
  })();
  $(function() {
    var h;
    return h = new Home;
  });
}).call(this);
