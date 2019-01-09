require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user){create(:user)}
  let(:cart){user.cart}
  let(:product1){create(:product, price: 1000)}
  let(:product2){create(:product, price: 2000)}
  let(:product3){create(:product, price: 3000)}

  describe "#remove_product" do
    context "when purchase products as same as argument's product exists," do
      before do
        cart.add_product(product1, 1)
        cart.remove_product(product1)
      end
      it "doesn't occur validation errors" do
        expect(cart.errors.size).to eq 0
      end
      it "destroys the purhcase product" do
        expect(cart.purchase_products.size).to eq 0
      end
      it "calculates cart attributes" do
        expect(cart.products_num)        .to eq 0
        expect(cart.total)               .to eq 0
      end
    end
    context "when purchase products as same as argument's product don't exist," do
      before do
        cart.add_product(product1, 5)
        cart.remove_product(product2)
      end
      it "doesn't occur validation errors" do
        expect(cart.errors.size).to eq 0
      end
      it "doesn't destroy the purchase product" do
        expect(cart.purchase_products.size).to eq 1
      end
      it "does nothing for the existed purchase product" do
        expect(cart.purchase_products.first.product_id).to eq product1.id
        expect(cart.purchase_products.first.name)      .to eq product1.name
        expect(cart.purchase_products.first.price)     .to eq product1.price
        expect(cart.purchase_products.first.num)       .to eq 5
        expect(cart.purchase_products.first.total)     .to eq 5000
      end
      it "does nothing for cart" do
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
