/* DO NOT MODIFY. This file was compiled Tue, 11 Oct 2011 11:47:01 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/home.coffee
 */

(function() {
  var Home, HomeView;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Home = (function() {
    __extends(Home, Backbone.Model);
    function Home() {
      this.price = __bind(this.price, this);
      Home.__super__.constructor.apply(this, arguments);
    }
    Home.prototype.initialize = function() {
      return this.shares = window.globals.carriers;
    };
    Home.prototype.price = function() {
      var amount, current_sector;
      current_sector = this.get("current_sector");
      if (current_sector) {
        amount = this.shares.sectors[current_sector].total * this.shares.total.amount;
      } else {
        amount = this.shares.total.amount;
      }
      return sprintf("%.1f", amount / 1000000000);
    };
    return Home;
  })();
  HomeView = (function() {
    __extends(HomeView, Backbone.View);
    function HomeView() {
      this.update_current_sector = __bind(this.update_current_sector, this);
      this.reset_current_sector = __bind(this.reset_current_sector, this);
      this.update_chart = __bind(this.update_chart, this);
      this.show_information = __bind(this.show_information, this);
      this.render = __bind(this.render, this);
      HomeView.__super__.constructor.apply(this, arguments);
    }
    HomeView.prototype.initialize = function() {
      this.max_height = 360;
      this.model = new Home();
      this.model.bind("change:current_sector", this.render);
      return this.render();
    };
    HomeView.prototype.model = Home;
    HomeView.prototype.el = "#map";
    HomeView.prototype.events = {
      "click #sector_icons a.description": "show_information",
      "mouseenter #sector_links .sector a": "update_current_sector",
      "mouseenter #sector_icons .sector": "update_current_sector",
      "mouseleave #sector_links .sector a": "reset_current_sector",
      "mouseleave #sector_icons .sector": "reset_current_sector"
    };
    HomeView.prototype.render = function() {
      var popup;
      this.sector_id = this.model.get("current_sector");
      if (this.sector_id) {
        popup = $("#sector_icons .sector[rel=" + this.sector_id + "] .popup");
        popup.show();
      } else {
        $(".popup").hide();
      }
      $("#chart header span.amount").html(this.model.price());
      this.update_chart();
      return this.el;
    };
    HomeView.prototype.show_information = function(e) {
      var container;
      console.log("Yo");
      e.preventDefault();
      container = $(e.target).parent();
      container.find(".text").toggle();
      return $(e.target).toggleClass("close_description");
    };
    HomeView.prototype.update_chart = function() {
      var carrier, carrier_li, new_height, ratio, ratios, shares, value, _results;
      shares = this.model.shares;
      if (this.sector_id) {
        ratios = shares.sectors[this.sector_id].carriers;
      } else {
        ratios = shares.total;
      }
      _results = [];
      for (carrier in ratios) {
        if (!__hasProp.call(ratios, carrier)) continue;
        ratio = ratios[carrier];
        new_height = this.max_height * ratio;
        carrier_li = $("ul.chart").find("." + carrier);
        carrier_li.stop(true).animate({
          "height": new_height
        }, 500);
        value = Math.round(ratio * 100);
        _results.push($("#chart tr." + carrier + " .value").html("" + value + "%"));
      }
      return _results;
    };
    HomeView.prototype.reset_current_sector = function() {
      return this.model.set({
        'current_sector': false
      });
    };
    HomeView.prototype.update_current_sector = function(e) {
      var sector_id;
      sector_id = $(e.target).attr("rel");
      return this.model.set({
        current_sector: sector_id
      });
    };
    return HomeView;
  })();
  $(function() {
    return window.h = new HomeView();
  });
}).call(this);
