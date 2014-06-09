require 'spec_helper'

describe Appointment do
  context "attribute validations" do
    it { should validate_presence_of :appointment_date }    
    it do 
      should ensure_inclusion_of(:status).
        in_array(%w{pending confirmed concluded canceled}).
        with_message("%{value} is not a valid status!") 
    end
    it { should validate_presence_of :user }
    it { should validate_presence_of :service }

  end

  context "model associations" do
    it { should belong_to :user }
    it { should belong_to :service }
  end

  context "scope: token_datetimes" do
    it "should retrieve only 'confirmed' and 'pending' appointments" do
      expect(Appointment.token_datetimes.count).to eq Appointment.where(status: ['pending','confirmed']).count
    end
    it "should retrieve dates as a valid format" do
      expect(Appointment.token_datetimes).to be_an_instance_of Array
      Appointment.token_datetimes.each do |token_datetime|
        expect(token_datetime).to be_a_kind_of Time
      end
    end
  end

  context "scope: by_datetime" do
    before(:each) { create_list(:appointment, 3) }
    it "should retrieve all Appointments" do
      expect(Appointment.all.count).to eq Appointment.by_datetime.count
    end
    it "should retrieve ordered by nearest datetime" do

      expect(Appointment.by_datetime.first.appointment_date).to eq Appointment.minimum(:appointment_date)
    end
  end

  context "scope: overdue" do
    before(:each) do
      Appointment.delete_all  
    end

    let(:appointment1) { build(:appointment) }
    let(:appointment2) { build(:appointment) }
    let(:appointment3) { build(:appointment) }

    it "returns all appointments which has a past date" do
      appointment1.appointment_date = DateTime.now - 1.hour
      appointment2.appointment_date = DateTime.now - 1.day
      appointment3.appointment_date = DateTime.now

      appointment1.save; appointment2.save; appointment3.save

      expect(Appointment.overdue.count).to eq 2
    end
    it "considers the date from the beginning of the hour" do
      appointment1.appointment_date = DateTime.now.beginning_of_hour - 1.second
      appointment2.appointment_date = DateTime.now.beginning_of_hour 
      appointment3.appointment_date = DateTime.now.beginning_of_hour + 1.second 

      appointment1.save; appointment2.save; appointment3.save

      expect(Appointment.overdue.count).to eq 1
    end
    it "only cares about 'pending' and 'confirmed' appointments" do
      appointment1.status = 'canceled'
      appointment1.appointment_date = DateTime.now - 1.week
      appointment2.status = 'confirmed'
      appointment2.appointment_date = DateTime.now - 1.week
      appointment3.status = 'pending'
      appointment3.appointment_date = DateTime.now.beginning_of_hour - 1.second

      appointment1.save; appointment2.save; appointment3.save

      expect(Appointment.overdue.count).to eq 2
    end
  end

  context "#destroyable?" do
    let(:appointment) { create(:appointment) }

    it "returns true if appointment is 'canceled'" do
      appointment.status = 'canceled'
      appointment.save!
      expect(appointment.destroyable?).to be_true
      
    end
    it "returns true if appointment is 'concluded'" do
      appointment.status = 'concluded'
      appointment.save!
      expect(appointment.destroyable?).to be_true
    end
    it "returns false if appointment is 'pending'" do
      appointment.status = 'pending'
      appointment.save!
      expect(appointment.destroyable?).to be_false
    end
    it "returns false if appointment is 'confirmed'" do
      appointment.status = 'confirmed'
      appointment.save!
      expect(appointment.destroyable?).to be_false
    end
    it "returns true if appointment is 'overdue'" do
      appointment.status = 'overdue'
      appointment.save!
      expect(appointment.destroyable?).to be_true
    end
  end

  context "#set_overdue_appointments" do
    before(:all) do
      Appointment.delete_all
      create_list(:appointment, 3)
      Appointment.update_all appointment_date: DateTime.now - 2.hour
    end
    it "sets all past appointments status to overdue" do
      Appointment.set_overdue_appointments
      expect(Appointment.pluck(:status).uniq).to match_array ['overdue']
    end
    it "does not alter 'updated_at' fields" do
      Appointment.all.each do |appointment|
        expect(appointment.created_at).to eq appointment.updated_at
      end
    end
  end

end
