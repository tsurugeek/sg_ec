require 'rails_helper'

RSpec.describe CodFee, type: :model do
  let(:cod_fee) { CodFee.current }

  describe "#calc" do
    it "returns nil when arg is nil" do
      expect(cod_fee.calc(nil)).to be_nil
    end
    it "returns nil when arg is less than 0" do
      expect(cod_fee.calc(-1)).to be_nil
    end
    it "returns 300 when arg >= 0 and arg < 10,000" do
      expect(cod_fee.calc(0)).to eq 300
      expect(cod_fee.calc(10_000-1)).to eq 300
    end
    it "returns 400 when arg >= 10,000 and arg < 30,000" do
      expect(cod_fee.calc(10_000)).to eq 400
      expect(cod_fee.calc(30_000-1)).to eq 400
    end
    it "returns 600 when arg >= 30,000 and arg < 100,000" do
      expect(cod_fee.calc(30_000)).to eq 600
      expect(cod_fee.calc(100_000-1)).to eq 600
    end
    it "returns 1000 when arg >= 100,000" do
      expect(cod_fee.calc(100_000)).to eq 1000
    end
  end
end
