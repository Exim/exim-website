// Add the expand/collapse functionality
	$('#chapters')
		.addClass('expandable')
		.find('.button')
		.click(function(){
			$(this).parent().toggleClass('open');
		});
	$('#options img.expand').click(function(){ $('.chapter').addClass('open'); });
	$('#options img.collapse').click(function(){ $('.chapter').removeClass('open') });
	$('#options').removeClass('hidden');
