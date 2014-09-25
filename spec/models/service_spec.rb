require 'spec_helper'

describe Service do
  context "attribute validations" do
    it { should validate_presence_of :name }    
    it { should validate_uniqueness_of :name }
    it { should ensure_length_of(:name).is_at_least(2).is_at_most(30) }
    it { should allow_value('aaa', 'bbb', 'cEcG').for(:name) }
    it { should_not allow_value('d3','!dwfgdfg','@%#%','234').for(:name) }

    it { should validate_presence_of :price }
    it { should validate_numericality_of :price }

    it { should validate_presence_of :duration }
    it { should validate_numericality_of :duration }
  end

  context "model associations" do
    it { should have_many(:appointments).dependent(:nullify) }
    it { should have_many(:users).through(:appointments) }    
  end
end
