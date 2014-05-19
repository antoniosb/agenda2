require 'spec_helper'

describe ServicesHelper do
  context "#number_to_currency_br" do
    it "format a number to brazilian currency" do
      number = 3
      expect(number_to_currency_br(number)).to match /^R\$\s[0-9]+\,[0-9]+/
    end
    it "returns nil if no number is passed" do
      expect(number_to_currency_br(nil)).to be_nil
    end
    it "accepts floating point numbers" do
      number = 6.54
      expect(number_to_currency_br(number)).to match /^R\$\s[0-9]+\,[0-9]+/
    end
  end
end
