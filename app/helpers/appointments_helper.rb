module AppointmentsHelper

  def available_datetimes_for_next_week(current_appointment_date=nil)
    raw_array = (Time.zone.now.beginning_of_hour.to_i .. (Time.zone.now + 1.week)
      .to_i).step(15.minutes).to_a - Appointment.token_datetimes.map(&:to_i)

    formatted_array = raw_array.map { |x| [ Time.zone.at(x).strftime('%A, %R (%d %B)'), Time.zone.at(x)] }

    if current_appointment_date
      formatted_array.unshift( [ Time.zone.at(current_appointment_date).strftime('%A, %R (%d %B)'), Time.zone.at(current_appointment_date)] )
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

  def disable_user_status(status)
    !current_user.admin? && [Appointment::CONFIRMED, Appointment::CONCLUDED, Appointment::PENDING].include?(status)
  end

  def disable_user_edition
    !current_user.admin? && action_name == 'edit'
  end

end