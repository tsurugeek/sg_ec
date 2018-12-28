require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product){create(:product)}

  describe "about validation" do
    it "空のnameは異常" do
      product = Product.new(name: nil)
      product.valid?
      expect(product.errors[:name].size).to be > 0
    end

    context "公開（hidden == false）の時" do
      let(:product){create(:product, hidden: false)}

      it "空のprice, sort_no, product_imageは異常とする" do
        product.price = nil
        product.sort_no = nil
        product.remove_product_image = nil
        product.valid?
        expect(product.errors[:price].size).to be > 0
        expect(product.errors[:sort_no].size).to be > 0
      end

      it "画像の削除は異常とする" do
        product.remove_product_image = "1"
        product.valid?
        expect(product.errors[:remove_product_image].size).to be > 0
      end
    end

    context "非公開（hidden == true）の時" do
      let(:product){create(:product, hidden: true)}

      it "空のprice, sort_no, product_imageは正常とする" do
        product.price = nil
        product.sort_no = nil
        product.valid?
        expect(product.errors[:price].size).to be 0
        expect(product.errors[:sort_no].size).to be 0
      end

      it "画像の削除は正常とする" do
        product.remove_product_image = "1"
        product.valid?
        expect(product.errors[:remove_product_image].size).to be 0
      end
    end
  end
end
