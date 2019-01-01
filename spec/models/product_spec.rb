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

  describe "#update_sort_nos" do
    let!(:product1){create(:product, sort_no: 0)}
    let!(:product2){create(:product, sort_no: 1)}
    let!(:product3){create(:product, sort_no: 2)}

    it "引数がnilの場合は処理を実施しない" do
      Product.update_sort_nos(nil)
      expect(product1.sort_no).to eq 0
      expect(product2.sort_no).to eq 1
      expect(product3.sort_no).to eq 2
    end

    it "引数が[]の場合は処理を実施しない" do
      Product.update_sort_nos([])
      expect(product1.sort_no).to eq 0
      expect(product2.sort_no).to eq 1
      expect(product3.sort_no).to eq 2
    end

    it "引数に指定されたidの配列の順番にsortnoを更新する" do
      Product.update_sort_nos([product2.id, product3.id, product1.id])
      expect(product1.reload.sort_no).to eq 2
      expect(product2.reload.sort_no).to eq 0
      expect(product3.reload.sort_no).to eq 1
    end

    it "引数に指定されいないProductのsortnoは0に更新する" do
      Product.update_sort_nos([product3.id, product1.id])
      expect(product1.reload.sort_no).to eq 1
      expect(product2.reload.sort_no).to eq 0
      expect(product3.reload.sort_no).to eq 0
    end
  end

end
