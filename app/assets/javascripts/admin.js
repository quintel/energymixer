//= require jquery
//= require jquery_ujs
//= require jquery-ui

$( function() {
    // Partition switcher.
    var field = $('header nav #partition select');

    field.change( function(event) {
        window.location.href =
            window.location.protocol + '//' +
            field.val() + '/admin';

        event.preventDefault();
    } );
} );
