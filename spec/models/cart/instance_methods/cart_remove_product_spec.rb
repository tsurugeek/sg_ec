require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) do
    user = create(:user)
    user.cart.add_product(product1, 5)
    user.cart
  end
  let(:product1){create(:product, price: 1000)}
  let(:product2){create(:product, price: 2000)}

  describe "#remove_product" do
    it "raises ActiveRecord::StaleObjectError when cart is old" do
      expect{ cart.remove_product(cart.lock_version - 1, product1) }.to raise_error(ActiveRecord::StaleObjectError)
    end

    context "when the cart has the same product as argument's product," do
      it "retruns true without validation errors" do
        expect(cart.remove_product(cart.lock_version, product1)).to be true
        expect(cart.errors.size).to eq 0
      end

      it "destroys the purhcase product" do
        expect(cart.remove_product(cart.lock_version, product1)).to be true
        expect(cart.purchase_products.size).to eq 0
      end

      it "calculates cart attributes" do
        expect(cart.remove_product(cart.lock_version, product1)).to be true
        expect(cart.products_num)        .to eq 0
        expect(cart.total)               .to eq 0
      end
    end

    context "when the cart doesn't have the same product as argument's product," do
      it "retruns true without validation errors" do
        expect(cart.remove_product(cart.lock_version, product2)).to be true
        expect(cart.errors.size).to eq 0
      end

      it "doesn't destroy the purchase product" do
        expect(cart.remove_product(cart.lock_version, product2)).to be true
        expect(cart.purchase_products.size).to eq 1
      end

      it "does nothing for the existed purchase product" do
        expect(cart.remove_product(cart.lock_version, product2)).to be true
        expect(cart.purchase_products.first.product_id).to eq product1.id
        expect(cart.purchase_products.first.name)      .to eq product1.name
        expect(cart.purchase_products.first.price)     .to eq product1.price
        expect(cart.purchase_products.first.num)       .to eq 5
        expect(cart.purchase_products.first.total)     .to eq 5000
      end

      it "does nothing for cart" do
        expect(cart.remove_product(cart.lock_version, product2)).to be true
        expect(cart.subtotal)            .to eq 5000
        expect(cart.products_num)        .to eq 5
        expect(cart.shipping_cost)       .to eq 600
        expect(cart.cod_fee)             .to eq 300
        expect(cart.consumption_tax_rate).to eq 8
        expect(cart.consumption_tax)     .to eq 472
        expect(cart.total)               .to eq 6372
      end
    end
  end
end
