$(document).ready(function() {
  $('.close').click(function() {
    $('.alert').fadeOut(1000);
  });

  $('#flash_notice, #flash_info, #flash_warning, #flash_error').fadeOut(3000);

});