class Appointment < ActiveRecord::Base
  APPOINTMENT_STATUS = %w{pending confirmed}
  belongs_to :service
  belongs_to :user

  validates_presence_of :service, :user
  validates :appointment_date, presence: true

  validates :status, 
      inclusion: { in: APPOINTMENT_STATUS, message: "%{value} is not a valid status!" }

  before_validation :downcase_status

private
    def downcase_status
      self.status = status.try(:downcase)
    end

end
