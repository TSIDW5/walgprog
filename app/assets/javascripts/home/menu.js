(function($) {

    skel.breakpoints({
        wide: '(min-width: 961px) and (max-width: 1880px)',
        normal: '(min-width: 961px) and (max-width: 1620px)',
        narrow: '(min-width: 961px) and (max-width: 1320px)',
        narrower: '(max-width: 960px)',
        mobile: '(max-width: 736px)'
    });

    $(function() {

        var	$window = $(window),
            $body = $('body');

        // Header (narrower + mobile).
        // Toggle.
        $(
            '<div id="headerToggle">' +
            '<a href="#header" class="toggle"></a>' +
            '</div>'
        )
            .appendTo($body);

        // Header.
        $('#header')
            .panel({
                delay: 500,
                hideOnClick: true,
                hideOnSwipe: true,
                resetScroll: true,
                resetForms: true,
                side: 'left',
                target: $body,
                visibleClass: 'header-visible'
            });
    });
})(jQuery);
