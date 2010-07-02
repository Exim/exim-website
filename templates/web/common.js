// Fix the header and navigation at the top of the page
	(function(){
		$('#header').addClass('fixed');
		if( $('#header').css('position') === 'fixed' ){
			$('.navigation')
				.before( $('.navigation').clone().addClass('spacer') )
				.addClass('fixed');
			$('#outer > .right_bar, #outer > .left_bar').addClass('display');
		}
	})();

// Add branding for mirrors
	if( document.location.href.match(/^https?:\/\/([^\/]+\.)*exim\.org\//) ){
		$('#branding').remove();
	} else {
		$('#branding').ready(function(){
			try {
				var doc = $('#branding')[0].contentWindow.document;
				if( doc.title.match(/\b(found|404)\b/i) ){ // Crude but "good enough" check to see if the branding request failed
					$('#branding').remove();
				} else {
					$(doc).find('a').each(function(){
						if( $(this).attr('title') == '' )
							$(this).attr('title','Sponsor of this mirror');
						$(this).css('opacity',0.8)
							.mouseover(function(){ $(this).css('opacity',1) })
							.mouseout(function(){ $(this).css('opacity',0.8) });
					});
					$('#branding')
						.height( $(doc).find('img').height() ? $(doc).find('img').height() + 16 + 'px' : 'auto' )
						.hide()
						.css('visibility','visible')
						.fadeIn(2000);
				}
			} catch(e){
				$('#branding').remove();
			}
		});
	}

// Footer
	(function(){
		$('#footer').hide();
		setTimeout( function(){ $('#footer').fadeIn('slow') }, 2000 );
	})();

// Search box
	(function(){

		// Add placeholder functionality to browsers which don't support it
			if( !('placeholder' in document.createElement('input')) )
				$('.navigation li.search input.search_field')
					.focus(function(e){
						if( $(this).val() === ' ' + $(this).attr('placeholder') )
							$(this).val('').css('color','#000');
					})
					.blur(function(e){
						if( $(this).val() === ' ' + $(this).attr('placeholder') || $(this).val() === '' )
							$(this).css('color','#666').val( ' ' + $(this).attr('placeholder') );
					}).blur();

		// Add rounded borders to search field on Gecko based browsers
			if( document.body.style.MozBorderRadius !== undefined )
				$('.search_field_container')
					.addClass('roundit')
					.click(function(){ $(this).find('input').focus() });
	})();

// Jump to the right location on the page. Fixed header can cause problems.
	if( $('#header').css('position') === 'fixed' ){

		// Jump to the given ID
			var jump = function( id ){
				if( $('#'+id).length == 0 ) return false;

				document.location.href = document.location.href.replace(/#.+/,'') + '#' + id;

				$('html,body').animate({
					scrollTop: $('#'+id).position()['top'] - $('#header').height() - $('.navigation.fixed').height() -5 
				}, 100);

				return true;
			};

		var uri		= document.location.pathname;
		var uri_end	= uri.replace(/^.*\//,'');

		// Page load
		        if( document.location.href.match(/#./) ) jump( document.location.href.replace(/^.*#(.+)$/,'$1') );

		// Anchor click
			$('a').live('click', function(e){
				var href = $(this).attr('href');
				if( !href.match(/^.*#.+$/) ) return true; // No # in the anchor

				var href_uri = href.replace(/^([^#]*)(#.*)?/,'$1'); // href without the #

				if( href_uri.match(/^([a-z]+:)?\/\//)               ) return true; // Ignore full URLs
				if( href_uri.match(/^[^\/]/) && href_uri != uri_end ) return true; // Ignore relative links to other pages
				if( href_uri.match(/^\//)    && href_uri != uri     ) return true; // Ignore absolute links to other pages

				if( jump( href.replace(/^.*#(.+)$/,'$1') ) ) e.preventDefault();
			});

		// For browsers which support it, detect when the hash in the address bar changes
			$(window).bind('hashchange',function(e){
				if( jump( document.location.href.replace(/^.*#(.+)$/,'$1') ) ) e.preventDefault();
			});
        }

