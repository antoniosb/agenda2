require 'spec_helper'

describe AppointmentsHelper do

  describe "#available_datetimes_for_next_week" do
    it "validates the output format that will be displayed in the view" do
      available_datetimes_for_next_week.each do |tuple|
        expect(tuple[0]).to match /[A-Z]{1}[a-z]+\, [0-9]{2}:[0-9]{2} \([0-9]{2} [A-Z]{1}[a-z]+\)/
      end
    end
    it "ensure a valid value for the controller" do
      available_datetimes_for_next_week.each do |tuple|
        expect(tuple[1]).to be_an_instance_of Time
      end
    end
  end
end
