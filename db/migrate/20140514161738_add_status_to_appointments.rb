class AddStatusToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :status, :string, null: false, default:"pending"
  end
end
