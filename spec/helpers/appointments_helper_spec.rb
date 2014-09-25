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
        expect(tuple[1]).to be_kind_of Time
      end
    end
  end

  describe "#color_for_status" do
    context "returns a label accondingly to 'Bootstrap' framework" do
      it { expect(color_for_status 'pending').to eq 'label-info' }
      
      it { expect(color_for_status 'confirmed').to eq 'label-success' }
        
      it { expect(color_for_status 'concluded').to eq 'label-warning' }
        
      it { expect(color_for_status 'canceled').to eq 'label-danger' }
    end
  end
  
end
