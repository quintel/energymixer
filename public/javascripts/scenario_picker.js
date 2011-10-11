/* DO NOT MODIFY. This file was compiled Tue, 11 Oct 2011 12:20:55 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/scenario_picker.coffee
 */

(function() {
  var ScenarioPicker;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  ScenarioPicker = (function() {
    __extends(ScenarioPicker, Backbone.View);
    function ScenarioPicker() {
      this.select_tab = __bind(this.select_tab, this);
      this.submit_form = __bind(this.submit_form, this);
      this.remove_element = __bind(this.remove_element, this);
      this.add_element = __bind(this.add_element, this);
      this.render = __bind(this.render, this);
      ScenarioPicker.__super__.constructor.apply(this, arguments);
    }
    ScenarioPicker.prototype.el = 'body';
    ScenarioPicker.prototype.initialize = function() {
      return this.render();
    };
    ScenarioPicker.prototype.events = {
      'change .selectable .scenario input': 'add_element',
      'click .scenario .remove_from_list a': 'remove_element',
      'click a.submit_form': 'submit_form',
      'click a.scenario_tab_picker': 'select_tab'
    };
    ScenarioPicker.prototype.render = function() {
      $("body").ajaxStart(function() {
        return $("#user_scenarios").busy({
          img: '/images/spinner.gif'
        });
      });
      $(".selectable .scenario input").attr("checked", false);
      return $("#selected .scenario input").attr("checked", true);
    };
    ScenarioPicker.prototype.add_element = function(e) {
      var element;
      if (this._selected_scenarios_count() >= 2) {
        $(e.target).attr('checked', false);
        alert("Je kunt maximaal 2 scenario's kiezen");
        return false;
      }
      $(e.target).attr('checked', true);
      element = $(e.target).closest("div.scenario");
      element.appendTo("#selected_scenarios");
      element.find(".actions").hide();
      element.find(".remove_from_list").show();
      return this._update_submit_link();
    };
    ScenarioPicker.prototype.remove_element = function(e) {
      var item;
      item = $(e.target).parents(".scenario");
      item.find(".actions").show();
      item.find(".remove_from_list").hide();
      item.find("input").attr('checked', false);
      item.appendTo('#user_scenarios');
      return this._update_submit_link();
    };
    ScenarioPicker.prototype.submit_form = function(e) {
      e.preventDefault();
      if (this._selected_scenarios_count() === 2) {
        return $("section#select form").submit();
      }
    };
    ScenarioPicker.prototype.select_tab = function(e) {
      var tab_selector;
      e.preventDefault();
      tab_selector = $(e.target).attr('href');
      $("a.scenario_tab_picker").removeClass('active');
      $(e.target).addClass('active');
      $(".tab").hide();
      return $(tab_selector).parent().show();
    };
    ScenarioPicker.prototype._selected_scenarios_count = function() {
      return $("#selected_scenarios input:checked").length;
    };
    ScenarioPicker.prototype._update_submit_link = function() {
      if (this._selected_scenarios_count() < 2) {
        return $("a.submit_form").removeClass('enabled').addClass('disabled');
      } else {
        return $("a.submit_form").removeClass('disabled').addClass('enabled');
      }
    };
    return ScenarioPicker;
  })();
  $(function() {
    return new ScenarioPicker();
  });
}).call(this);
