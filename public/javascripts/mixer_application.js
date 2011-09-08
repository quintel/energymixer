/* DO NOT MODIFY. This file was compiled Thu, 08 Sep 2011 13:14:31 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/mixer_application.coffee
 */

(function() {
  this.App = (function() {
    function App() {
      this.mixer = new Mixer(this);
      this.graph = new Graph(this);
      this.questions = new Questions(this);
      this.score = new Score(this);
    }
    return App;
  })();
  $(function() {
    return window.app = new App;
  });
}).call(this);
