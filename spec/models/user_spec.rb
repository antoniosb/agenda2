require 'spec_helper'

describe User do

  context "attribute validations" do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end

  context "model associations" do
    it { should have_many(:appointments).dependent(:destroy) }
    it { should have_many(:services).through(:appointments) }
  end

end
