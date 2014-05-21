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
        #expect(token_datetime).to be_an_instance_of DateTime
        expect(token_datetime).to be_a_kind_of Time
      end
    end
  end
end
