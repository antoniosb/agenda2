jQuery(function($) {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });

  $(".status-color").each(function(){
      var status = $(this).html().toLowerCase().trim();

      switch(status){
        case('pending'):
          $(this).parent().addClass('label-info');
          break;
        case('confirmed'):
          $(this).parent().addClass('label-success');
          break;
        case('canceled'):
          $(this).parent().addClass('label-danger');
          break;
        case('concluded'):
          $(this).parent().addClass('label-warning');
          break;
        default:
          $(this).parent().addClass('label-default');
      }
  });

})