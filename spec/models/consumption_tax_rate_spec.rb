require 'rails_helper'

RSpec.describe ConsumptionTaxRate, type: :model do
  describe ".calc" do
    it "returns nil when arg is nil" do
      expect(ConsumptionTaxRate.calc_current(nil)).to be_nil
    end
    it "returns 8% of argument with floored" do
      expect(ConsumptionTaxRate.calc_current(10)).to eq 0
      expect(ConsumptionTaxRate.calc_current(11)).to eq 0
      expect(ConsumptionTaxRate.calc_current(12)).to eq 0
      expect(ConsumptionTaxRate.calc_current(13)).to eq 1
      expect(ConsumptionTaxRate.calc_current(14)).to eq 1
      expect(ConsumptionTaxRate.calc_current(15)).to eq 1
      expect(ConsumptionTaxRate.calc_current(16)).to eq 1
      expect(ConsumptionTaxRate.calc_current(17)).to eq 1
      expect(ConsumptionTaxRate.calc_current(18)).to eq 1
      expect(ConsumptionTaxRate.calc_current(19)).to eq 1
      expect(ConsumptionTaxRate.calc_current(20)).to eq 1
      expect(ConsumptionTaxRate.calc_current(21)).to eq 1
      expect(ConsumptionTaxRate.calc_current(22)).to eq 1
      expect(ConsumptionTaxRate.calc_current(23)).to eq 1
      expect(ConsumptionTaxRate.calc_current(24)).to eq 1
      expect(ConsumptionTaxRate.calc_current(25)).to eq 2
      expect(ConsumptionTaxRate.calc_current(26)).to eq 2
      expect(ConsumptionTaxRate.calc_current(99)).to eq 7
      expect(ConsumptionTaxRate.calc_current(100)).to eq 8
    end
  end
end
