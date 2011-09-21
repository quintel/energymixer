/* DO NOT MODIFY. This file was compiled Wed, 21 Sep 2011 13:23:45 GMT from
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
    Home.prototype.reset_carriers = function() {
      return this.update_carriers('total', 1000);
    };
    Home.prototype.update_carriers = function(key, speed) {
      if (typeof speed === "undefined") {
        speed = 350;
      }
      return this._update_carriers(this.shares[key], speed);
    };
    Home.prototype._update_carriers = function(carrier_values, speed) {
      var carrier, carrier_li, formatted_amount, label, money_bar_height, new_height, original_height, total_amount, value;
      total_amount = 0;
      money_bar_height = 0;
      for (carrier in carrier_values) {
        if (!__hasProp.call(carrier_values, carrier)) continue;
        value = carrier_values[carrier];
        total_amount += value;
        original_height = this.original_height[carrier];
        new_height = Math.round(value / this.shares["total"][carrier] * original_height);
        carrier_li = $("ul.chart").find("." + carrier);
        carrier_li.stop(true).animate({
          "height": new_height
        }, speed);
        label = carrier_li.find(".label");
        if (new_height > 11) {
          label.show();
        } else {
          label.hide();
        }
        money_bar_height += new_height;
      }
      formatted_amount = sprintf("%.1f", total_amount / 1000000000);
      $("#chart header span.amount").html(formatted_amount);
      return $("ul.chart li.money").stop(true).animate({
        "height": money_bar_height + 8
      }, speed);
    };
    Home.prototype._save_original_height = function() {
      return this.original_height = {
        coal: $("ul.chart li.coal").height(),
        gas: $("ul.chart li.gas").height(),
        oil: $("ul.chart li.oil").height(),
        nuclear: $("ul.chart li.nuclear").height(),
        renewable: $("ul.chart li.renewable").height()
      };
    };
    Home.prototype.setup_callbacks = function() {
      $("#sector_links .sector").hover(__bind(function(e) {
        var sector_id;
        sector_id = $(e.target).parent().attr("id");
        return this.update_carriers(sector_id);
      }, this), __bind(function() {
        return this.reset_carriers();
      }, this));
      $("#sector_icons .sector").hover(__bind(function(e) {
        var sector_id;
        $(e.target).find(".popup").show();
        sector_id = $(e.target).attr("id");
        return this.update_carriers(sector_id);
      }, this), __bind(function(e) {
        $(".popup").hide();
        return this.reset_carriers();
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
