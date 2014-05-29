class Appointment < ActiveRecord::Base
  APPOINTMENT_STATUS = %w{pending confirmed concluded canceled}
  CANCELED =     'canceled'
  CONCLUDED =    'concluded'
  PENDING =      'pending'
  CONFIRMED =    'confirmed'
  
  belongs_to :service
  belongs_to :user

  validates_presence_of :service
  validates_presence_of :user

  validates :appointment_date, presence: true

  validates_uniqueness_of :appointment_date, conditions: -> { where(status:['pending', 'confirmed']) }

  validates :status, 
      inclusion: { in: APPOINTMENT_STATUS, message: "%{value} is not a valid status!" }

  before_validation :downcase_status

  scope :token_datetimes, -> { Appointment.where( status:['pending','confirmed']).pluck(:appointment_date) }

  scope :by_datetime, -> { Appointment.order(:appointment_date) }

private
    def downcase_status
      self.status = status.try(:downcase)
    end

end
