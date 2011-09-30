/* DO NOT MODIFY. This file was compiled Fri, 30 Sep 2011 07:20:15 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/home.coffee
 */

(function() {
  var Home;
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Home = (function() {
    function Home() {
      this.current_sector = false;
      this.max_height = 360;
      this.shares = globals.carriers;
      this.setup_callbacks();
    }
    Home.prototype._update_price = function() {
      var amount, formatted_amount;
      if (this.current_sector) {
        amount = this.shares.sectors[this.current_sector].total * this.shares.total.amount;
      } else {
        amount = this.shares.total.amount;
      }
      formatted_amount = sprintf("%.1f", amount / 1000000000);
      return $("#chart header span.amount").html(formatted_amount);
    };
    Home.prototype._update_chart = function() {
      var carrier, carrier_li, new_height, ratio, ratios, _results;
      if (this.current_sector) {
        ratios = this.shares.sectors[this.current_sector].carriers;
      } else {
        ratios = this.shares.total;
      }
      _results = [];
      for (carrier in ratios) {
        if (!__hasProp.call(ratios, carrier)) continue;
        ratio = ratios[carrier];
        new_height = this.max_height * ratio;
        carrier_li = $("ul.chart").find("." + carrier);
        _results.push(carrier_li.stop(true).animate({
          "height": new_height
        }, 500));
      }
      return _results;
    };
    Home.prototype._update_percentages = function() {
      var carrier, ratio, ratios, value, _results;
      if (this.current_sector) {
        ratios = this.shares.sectors[this.current_sector].carriers;
      } else {
        ratios = this.shares.total;
      }
      _results = [];
      for (carrier in ratios) {
        if (!__hasProp.call(ratios, carrier)) continue;
        ratio = ratios[carrier];
        value = Math.round(ratio * 100);
        _results.push($("#chart tr." + carrier + " .value").html("" + value + "%"));
      }
      return _results;
    };
    Home.prototype.reset_map = function() {
      this.current_sector = false;
      return this.update_map();
    };
    Home.prototype.update_map = function() {
      this._update_price();
      this._update_chart();
      return this._update_percentages();
    };
    Home.prototype.setup_callbacks = function() {
      $("#sector_links .sector a, #sector_icons .sector").hover(__bind(function(e) {
        var popup, sector_id;
        sector_id = $(e.target).attr("rel");
        popup = $("#sector_icons .sector[rel=" + sector_id + "] .popup");
        popup.show();
        this.current_sector = sector_id;
        return this.update_map();
      }, this), __bind(function(e) {
        $(".popup").hide();
        return this.reset_map();
      }, this));
      return $("#sector_icons a").click(__bind(function(e) {
        var container;
        e.preventDefault();
        container = $(e.target).parent();
        container.find(".text").toggle();
        return $(e.target).toggleClass("close_description");
      }, this));
    };
    return Home;
  })();
  $(function() {
    var h;
    return h = new Home;
  });
}).call(this);
