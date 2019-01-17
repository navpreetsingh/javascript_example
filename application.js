// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.11.1.min
//= require jquery_ujs
//= require jquery-ui-1.10.3.min
//= require bootstrap.min	
//= require jquery.nicescroll.min

$(document).ready(
	function() {
		$(".limit_content").niceScroll({cursorcolor:"#f75b49",cursorborderradius:"0px"});
	}
);