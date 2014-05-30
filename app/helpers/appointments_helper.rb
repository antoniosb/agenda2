module AppointmentsHelper

  def available_datetimes_for_next_week(current_appointment_date=nil)
    raw_array = (DateTime.now.beginning_of_hour.to_i .. (DateTime.now + 1.week)
      .to_i).step(15.minutes).to_a - Appointment.token_datetimes.map(&:to_i)

    formatted_array = raw_array.map { |x| [ Time.at(x).strftime('%A, %R (%d %B)'), Time.at(x)] }

    if current_appointment_date
      formatted_array.unshift( [ Time.at(current_appointment_date).strftime('%A, %R (%d %B)'), Time.at(current_appointment_date)] )
    else
      formatted_array
    end
    
  end

  def color_for_status(status)
    case status
    when 'pending'
      'label-info'
    when 'confirmed'
      'label-success'
    when 'concluded'
      'label-warning'
    when 'canceled'
      'label-danger'
    else
      'label-default'
    end
  end

end