class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :user
      t.belongs_to :service
      t.datetime :appointment_date
      t.timestamps
    end
  end
end
