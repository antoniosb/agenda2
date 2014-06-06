
$(document).ready(function(){

  var user = $("meta[name=user_id]").attr("content");
  var isAdmin = $("meta[name=is_admin]").attr("content");

  PrivatePub.subscribe("/appointments/"+user, function(data, channel){
    var action = data.action_name;
    var appointment = $.parseJSON(data.appointment);
    var adminChannel = false;
    if(action=='update'){
      var service = $.parseJSON(data.service);
      var user = $.parseJSON(data.user);
      make_appointment_row(appointment, user, service, adminChannel);
      colorize_appointments();
    }else if(action=='destroy'){
      remove_appointment_row(appointment);
    };

  });

  PrivatePub.subscribe("/appointments/all", function(data, channel){
    var action = data.action_name;
    var appointment = $.parseJSON(data.appointment);
    var adminChannel = true;
    var service = $.parseJSON(data.service);
    var user = $.parseJSON(data.user);
    make_appointment_row(appointment, user, service, adminChannel);
    colorize_appointments();


  });

//it makes every table row (which is an appointment description) clickable
  make_table_row_clickable();

//makes a table cell clickable for another event
  make_table_cell_clickable();

//it makes the table rows colored depending on its status
  colorize_appointments();

//it shows the form errors on a proper location
  $(document).bind('ajaxError', 'form#new_appointment', function(event, jqxhr, settings, exception){
    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  });

//it prevents the div that show errors not to appear
  $('.create-appointment').click(function(){
    $('#help-block').fadeIn(1000);
  });

//it populates the available dates of the appointment form
  $('#new_appointment_link').click(function(){
    fetch_appointments_dates();
  });

//it ensures that the options won't be duplicated
  $('div#new_appointment_modal').on('hidden.bs.modal', function () {
    $('#appointment_appointment_date').find('option').remove();
  });

//change status when click on index
  if(isAdmin == 'true'){ 
    toggle_status();
  };


});

(function($) {

//handles a successfull modal appearance
  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');

    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form select"]').attr('selectedIndex', '0');

    // clear error state
    this.clear_previous_errors();
  };

//handles a error modal appearance
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

//handles the cleaning between modals appearances
  $.fn.clear_previous_errors = function(){
    $('.input-group.has-error', this).each(function(){
      $(this).removeClass('has-error');
    });

    $('#help-block').html('');
    $('#help-block').removeClass('alert alert-danger');
    

  }

}(jQuery));

//makes the appointments table colored
var colorize_appointments = function(){
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
};

//populates the select tag of the appointments form with available dates
var fetch_appointments_dates = function(){
  $.post('/appointments_dates').success(function(data){
    data_array = $.parseJSON(data);
    $.each(data_array, function(index, value){
      $('#appointment_appointment_date').append("<option value='"+value[1]+"'>"+value[0]+"</option>");
    });
  });
};

var make_appointment_row = function(appointment, user, service, admin){
  var formatted_appointment_date = $.format.date(appointment.appointment_date, "ddd, HH:mm (dd MMM)");
  var newTr = "<tr data-link='/appointments/"+appointment.id+"/edit' id="+appointment.id+"> \
                <td>"+formatted_appointment_date+"</td> \
                <td class='status-color'>"+appointment.status+"</td> \
                  <td>"+user.name+"</td> \
                  <td>"+service.name+"</td>";      
  if(admin){
    newTr += "<td class='removable-item text-center'> \
                  <input id='appointments_' type='checkbox' value="+appointment.id+" \
                    name='appointments[]'></input></td> \
              </tr> "
  }else{
    newTr += "<td></td></tr>"
  }

  //still on the same user
  if( $('tr#'+appointment.id).length > 0){
    $('tr#'+appointment.id).replaceWith(newTr);
  }//went to a new user
  else{
    $('tbody').append(newTr);
  };
  $('tr#'+appointment.id).css('text-transform', 'capitalize');

};

var remove_appointment_row = function(appointment){
  $('tr#'+appointment.id).fadeOut(1000, 'linear', function(){
    $(this).remove();
  });
};

var make_table_row_clickable = function(){
  $("tr[data-link]").click(function() {
      window.location = this.dataset.link;
      fetch_appointments_dates();
    });
};

var toggle_status = function(){

  $('tr td.change-status').click(function(e){
    e.stopPropagation();

    $.post('/rotate_appointment_status', 
        {status_name : $(this).data("status-name"), appointment_id: $(this).data("appointment-id") }, 
        function(appointment){          
          $('tr td.change-status[data-appointment-id='+appointment.id+']')
            .html(appointment.status)
            .css('text-transform','capitalize')
            .data('status-name',appointment.status)
            .parent().removeClass();
          colorize_appointments();


          var status =[];
          $('table tbody').find('tr').each(function(idx, elem){
            status.push( $(this).find('td').eq(1).text().toLowerCase() );
          });
  
          status = status.filter(function(elem){
            return ['canceled', 'concluded'].indexOf(elem) != -1
          });

          if ( (status.length <= 0) && ($('table th:last').has('input').length > 0) ){
            $('table th:last').remove();
          }

          if( $.inArray(appointment.status, ['confirmed', 'pending']) != -1 ){
            $('tr td.change-status[data-appointment-id='+appointment.id+']')
              .parent().find('td:last').html('');
          } else {
              var html = " \
                <input id='appointments_' type='checkbox' \
                  value="+appointment.id+" name='appointments[]''></input> ";
              $('tr td.change-status[data-appointment-id='+appointment.id+']')
              .parent().find('td:last').html(html).addClass('removable-item text-center');
              
              //add button
              if($('table th:last').has('input').length <= 0){
                $('table tr:first').append(" <th class='col-md-1 btn btn-danger btn-sm'> \
                    <input type='submit' value='Delete Selected' style='border: 0;background:none;' \
                     name='commit'></input></th>");
              }
          };
          make_table_cell_clickable();
    });
  });

};

var make_table_cell_clickable = function(){
    $("tr td.removable-item").click(function(e){
    e.stopPropagation();
  });
};