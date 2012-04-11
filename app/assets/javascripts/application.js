// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Utility method
// http://stackoverflow.com/questions/1890203/unique-for-arrays-in-javascript
function unique(arr) {
  var hash = {}, result = [];
  for ( var i = 0, l = arr.length; i < l; ++i ) {
    if ( !hash.hasOwnProperty(arr[i]) ) { //it works with objects! in FF, at least
      hash[ arr[i] ] = true;
      result.push(arr[i]);
    }
  }
  return result;
}

function is_not_ie7(){
  !(navigator.appVersion.indexOf("MSIE 7.") != -1);
}