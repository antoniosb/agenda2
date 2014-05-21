module AppointmentsHelper

def available_datetimes_for_next_week
  raw_array = (DateTime.now.beginning_of_hour.to_i .. (DateTime.now + 1.week)
    .to_i).step(15.minutes).to_a - Appointment.token_datetimes.map(&:to_i)

  raw_array.map { |x| [ Time.at(x).strftime('%A, %R (%d %B)'), Time.at(x)] }
  end
end