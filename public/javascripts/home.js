/* DO NOT MODIFY. This file was compiled Thu, 22 Sep 2011 08:01:33 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/home.coffee
 */

(function() {
  var Home;
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Home = (function() {
    function Home() {
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
    Home.prototype.reset_map = function() {
      this.current_sector = null;
      return this.update_map();
    };
    Home.prototype.update_map = function() {
      this._update_price();
      return this._update_chart();
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
