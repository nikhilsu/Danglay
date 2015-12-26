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
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree
//= require selectize

$('.dropdown-toggle').click(function() {
    var dropdownList = $('.dropdown-menu');
    var dropdownOffset = $(this).offset();
    var offsetLeft = dropdownOffset.left;
    var dropdownWidth = dropdownList.width();
    var docWidth = $(window).width();

    var subDropdown = $('.dropdown-menu').eq(1);
    var subDropdownWidth = subDropdown.width();

    var isDropdownVisible = (offsetLeft + dropdownWidth <= docWidth);
    var isSubDropdownVisible = (offsetLeft + dropdownWidth + subDropdownWidth <= docWidth);

    if (!isDropdownVisible || !isSubDropdownVisible) {
        $('.dropdown-menu').addClass('pull-right');
    } else {
        $('.dropdown-menu').removeClass('pull-right');
    }
});
