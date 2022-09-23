jQuery(document).ready(function($){
 $(".left-corder-container-button").hover(function() {
    $(".long-text").addClass("show-long-text");   
}, function () {
    $(".long-text").removeClass("show-long-text");
}); 
	$(window).scroll(function () {
	            if ($(this).scrollTop() > 500) {
	                $('#back-to-top').fadeIn();
	            } else {
	                $('#back-to-top').fadeOut();
	            }
	});
        // scroll body to 0px on click
	$('#back-to-top').click(function () {
	    $('#back-to-top').tooltip('hide');
	    $('body,html').animate({
	        scrollTop: 0
	    }, 800);
	    return false;
	});
        
        $('#back-to-top').tooltip('show');


});