/* DO NOT MODIFY. This file was compiled Tue, 11 Oct 2011 15:56:35 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/mixer_application.coffee
 */

(function() {
  var App;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  App = (function() {
    __extends(App, Backbone.Model);
    function App() {
      App.__super__.constructor.apply(this, arguments);
    }
    App.prototype.initialize = function() {
      this.mixer = new Mixer(this);
      this.chart = new Chart({
        model: this
      });
      this.questions = new Questions({
        model: this
      });
      return this.score = new Score({
        model: this
      });
    };
    return App;
  })();
  $(function() {
    return window.app = new App;
  });
}).call(this);
