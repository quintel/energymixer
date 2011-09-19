/* DO NOT MODIFY. This file was compiled Mon, 19 Sep 2011 14:01:44 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/popups.coffee
 */

(function() {
  $(function() {
    return $(".chart .renewable").hover(function() {
      return $(this).parents(".charts_container").find(".renewables_float").show();
    }, function() {
      return $(".renewables_float").hide();
    });
  });
}).call(this);
