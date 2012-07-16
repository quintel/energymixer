if( window['console'] === undefined ) {
    window.console = {
        log:   $.noop,
        debug: $.noop,
        info:  $.noop,
        warn:  $.noop,
        error: $.noop
    };
}
