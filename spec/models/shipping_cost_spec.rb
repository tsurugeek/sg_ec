require 'rails_helper'

RSpec.describe ShippingCost, type: :model do
  context ".calc_current" do
    it "returns nil when arg is nil" do
      expect(ShippingCost.calc_current(nil)).to be_nil
    end
    it "returns sum of 600 yen which added in every 5 product_nums" do
      expect(ShippingCost.calc_current(0)).to eq 0
      expect(ShippingCost.calc_current(1)).to eq 600
      expect(ShippingCost.calc_current(2)).to eq 600
      expect(ShippingCost.calc_current(3)).to eq 600
      expect(ShippingCost.calc_current(4)).to eq 600
      expect(ShippingCost.calc_current(5)).to eq 600
      expect(ShippingCost.calc_current(6)).to eq 1200
      expect(ShippingCost.calc_current(7)).to eq 1200
      expect(ShippingCost.calc_current(8)).to eq 1200
      expect(ShippingCost.calc_current(9)).to eq 1200
      expect(ShippingCost.calc_current(10)).to eq 1200
      expect(ShippingCost.calc_current(11)).to eq 1800
      expect(ShippingCost.calc_current(12)).to eq 1800
    end
  end
end
