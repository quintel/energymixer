//= require jquery
//= require jquery_ujs
//= require jquery-ui

$( function() {
    // Partition switcher.
    var field = $('header nav #partition select');

    field.change( function(event) {
        var splitHost, hostWithoutSubdomain;

        splitHost            = window.location.host.split('.');
        hostWithoutSubdomain = splitHost.slice(1, splitHost.length).join('.');

        window.location.href =
            window.location.protocol + '//' +
            field.val() + '.' + hostWithoutSubdomain + '/admin';

        event.preventDefault();
    } );
} );
