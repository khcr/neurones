$(function() {
	if(document.location.hash == "#log" && !$('#login .big-forms').is(':visible')) {
			$.getScript('/login' ) ;
		}
	$(window).on('hashchange', function() {
		if(document.location.hash == "#log" && !$('#login .big-forms').is(':visible')) {
			$.getScript('/login' ) ;
		}
	});
	// to keep login visible at top
	$(window).scroll(function(){

		if ($('#login .big-forms').is(':visible')) {

			if ($(this).scrollTop() > (119+343)) {  
		    $('#login .login').css({position: 'relative', top: $(this).scrollTop()-(120+344), right: '0'});
		  } else {
		    $('#login .login').css({position: 'relative', top: 'inherit', right: 'inherit'});
		  }

		} else {

			if ($(this).scrollTop() > 119) {  
		    $('#login .login').css({position: 'relative', top: $(this).scrollTop()-120, right: '0'});
		  } else {
		    $('#login .login').css({position: 'relative', top: 'inherit', right: 'inherit'});
		  }

		}

	});

	// for sign in popup see in sessions/login.je.erb

});