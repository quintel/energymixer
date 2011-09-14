/* DO NOT MODIFY. This file was compiled Wed, 14 Sep 2011 08:25:43 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/mixer_application.coffee
 */

(function() {
  this.App = (function() {
    function App() {
      this.mixer = new Mixer(this);
      this.chart = new Chart(this);
      this.questions = new Questions(this);
      this.score = new Score(this);
    }
    return App;
  })();
  $(function() {
    return window.app = new App;
  });
}).call(this);
