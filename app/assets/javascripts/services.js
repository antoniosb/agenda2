$(document).ready(function(){

  $(document).bind('ajaxError', 'form#new_service', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

  make_table_row_clickable();

  $('.create-service').click(function(){
    $('#help-block').fadeIn(1000);
  });

});

(function($) {

  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');

    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="text"]').val('');
    this.find('form input[type="text"]').attr('placeholder','default');
    this.find('form input[type="number"]').val('');
    this.find('form input[type="number"]').attr('placeholder', '0');

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.render_form_errors = function(errors){

    $form = this;
    this.clear_previous_errors();
    model = this.data('model');
  
    $('#help-block').addClass('alert alert-danger');
    $('#help-block').append("<span class='glyphicon glyphicon-remove-sign'></span><strong>&nbsp;&nbsp;Invalid data:</strong></br><div id='inner-help-block'></div>");
    
    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.input-group').addClass('has-error');
        $.each(messages, function(index, msg) {
          $('#inner-help-block').append("<span><strong>"+field+"</strong>&nbsp;"+msg+"</span></br>");
        });

    });
    $('#help-block').css('text-transform','capitalize');

  };

  $.fn.clear_previous_errors = function(){
    $('.input-group.has-error', this).each(function(){
      $(this).removeClass('has-error');
    });

    $('#help-block').html('');
    $('#help-block').removeClass('alert alert-danger');


  }

}(jQuery));

var make_table_row_clickable = function(){
  $("tr[data-link]").click(function() {
      window.location = this.dataset.link;
    });
};