(function($){
	$('p.manual_info select').each(function(){
		$(this).change(function(e){
			if( $(this).val().match(/^[0-9\.]+$/) ){
				var href = $(this).parent().find('a').attr('href').replace('-current/','-'+$(this).val()+'/');
				document.location.href=href;
			}
		});
	});
})(jQuery);
