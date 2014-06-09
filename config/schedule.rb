set :output, "/home/antonio/Public/appointments/agenda2/log/cron_log.log"

every :day, :at => '12:05 am' do  
  runner "Appointment.set_overdue_appointments"
end