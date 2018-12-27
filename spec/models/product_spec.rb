require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product){create(:product)}

  describe "about validation" do
    it "空のnameは異常" do
      product = Product.new(name: nil)
      product.valid?
      expect(product.errors[:name].size).to be > 0
    end

    context "hidden == false の時" do
      it "空のpriceまたはsort_noは異常" do
        product.hidden = false
        product.price = nil
        product.sort_no = nil
        product.valid?
        expect(product.errors[:price].size).to be > 0
        expect(product.errors[:sort_no].size).to be > 0
      end
    end

    context "hidden == true の時" do
      it "空のpriceまたはsort_noは正常" do
        product.hidden = true
        product.price = nil
        product.sort_no = nil
        product.valid?
        expect(product.errors[:price].size).to be 0
        expect(product.errors[:sort_no].size).to be 0
      end
    end
  end
end
