// Sidebar table of contents
(function ($) {

    var click_func = function (e) {
        e.stopPropagation();
        if ($('#toc').data('opened')) {
            $('#toc > *').animate({
                left: '-=' + $('#toc > ul').width() + 'px'
            }, 'fast');
            $('#toc').removeData('opened');
        } else {
            $('#toc > *').animate({
                left: '+=' + $('#toc > ul').width() + 'px'
            }, 'fast');
            $('#toc').data('opened', 1);
        }
    };

    $('body').click(function () {
        if( $('#toc').data('opened') ) $('#toc > img').mousedown();
    });

    var type = document.location.pathname.match(/\/doc\/html\/spec_html\/filter/) ? 'filter' : 'spec';

    // Get the relevant table of contents
    $.get(type === 'spec' ? 'index_toc.xml' : 'filter_toc.xml', function (xml) {

        // Remove the main list from the DOM for performance
        var $ul = $('#toc > ul').remove();

        // Traverse chapters
        var chapter_id = 0;
        $(xml).find('c').each(function () {
            ++chapter_id;
            var chapter_title = $(this).children('t').text();
            var chapter_url = $(this).children('u').text();

            var chapter_li = $('<li/>').append(
            $('<a/>').attr({
                href: chapter_url,
                title: chapter_title
            }).text(chapter_id + '. ' + chapter_title), $('<ul/>').hide()).appendTo($ul);
        });

        $('#toc img').fadeIn('slow', function () {
            // Add the main list back to the DOM
            $ul.removeClass('hidden').css('visibility', 'hidden').appendTo('#toc').css('left', '-' + $ul.width() + 'px').css('visibility', 'visible');
            $('#toc > img').mousedown(click_func);
            $('#toc > ul').click(click_func);
            $('#toc, #toc a').click(function (e) {
                e.stopPropagation()
            });
        });
    });
})(jQuery);
