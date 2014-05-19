require 'spec_helper'

describe Appointment do
  context "attribute validations" do
    it { should validate_presence_of :appointment_date }    
    it do 
      should ensure_inclusion_of(:status).
        in_array(%w{pending confirmed}).
        with_message("%{value} is not a valid status!") 
    end
    it { should validate_presence_of :user }
    it { should validate_presence_of :service }

  end

  context "model associations" do
    it { should belong_to :user }
    it { should belong_to :service }
  end
end
