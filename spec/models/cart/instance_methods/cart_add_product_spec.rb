require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user){create(:user)}
  let(:cart){user.cart}
  let(:product1){create(:product, price: 1000)}
  let(:product2){create(:product, price: 2000)}
  let(:product3){create(:product, price: 3000)}

  describe "#add_product" do
    # context "when ther argument num passed less than 1," do
    # end
    context "when any purchase products don't exist," do
      before do
        cart.add_product(product1, 5)
      end
      it "doesn't occur validation errors" do
        expect(cart.errors.size).to eq 0
      end
      it "creates a new cart product" do
        expect(cart.products.size).to eq 1
      end
      it "calculates purchase product attributes" do
        expect(cart.purchase_products.first.product_id).to eq product1.id
        expect(cart.purchase_products.first.name)      .to eq product1.name
        expect(cart.purchase_products.first.price)     .to eq product1.price
        expect(cart.purchase_products.first.num)       .to eq 5
        expect(cart.purchase_products.first.total)     .to eq 5000
      end
      it "calculates cart attributes" do
        expect(cart.subtotal)            .to eq 5000
        expect(cart.products_num)        .to eq 5
        expect(cart.shipping_cost)       .to eq 600
        expect(cart.cod_fee)             .to eq 300
        expect(cart.consumption_tax_rate).to eq 8
        expect(cart.consumption_tax)     .to eq 472
        expect(cart.total)               .to eq 6372
      end
    end
    context "when purchase products already exists," do
      before do
        cart.add_product(product1, 5)
        cart.add_product(product2, 3)
      end
      it "doesn't occur validation errors" do
        expect(cart.errors.size).to eq 0
      end
      it "creates a new cart product" do
        expect(cart.products.size).to eq 2
      end
      it "calculates purchase product attributes" do
        purchase_product = cart.purchase_products.find_by(product: product2)
        expect(purchase_product.product_id).to eq product2.id
        expect(purchase_product.name)      .to eq product2.name
        expect(purchase_product.price)     .to eq product2.price
        expect(purchase_product.num)       .to eq 3
        expect(purchase_product.total)     .to eq 6000
      end
      it "calculates cart attributes" do
        expect(cart.subtotal)            .to eq (5000 + 6000)
        expect(cart.products_num)        .to eq (5 + 3)
        expect(cart.shipping_cost)       .to eq 600 * 2
        expect(cart.cod_fee)             .to eq 400
        expect(cart.consumption_tax_rate).to eq 8
        expect(cart.consumption_tax)     .to eq 1008
        expect(cart.total)               .to eq 13608
      end
    end
    context "when purchase products as same as argument's product already exists," do
      before do
        cart.add_product(product1, 5)
        cart.add_product(product1, 3)
      end
      it "doesn't occur validation errors" do
        expect(cart.errors.size).to eq 0
      end
      it "doesn't create a new cart product" do
        expect(cart.products.size).to eq 1
      end
      it "calculates purchase product attributes" do
        expect(cart.purchase_products.first.product_id).to eq product1.id
        expect(cart.purchase_products.first.name)      .to eq product1.name
        expect(cart.purchase_products.first.price)     .to eq product1.price
        expect(cart.purchase_products.first.num)       .to eq (5 + 3)
        expect(cart.purchase_products.first.total)     .to eq 8000
      end
      it "calculates cart attributes" do
        expect(cart.subtotal)            .to eq 8000
        expect(cart.products_num)        .to eq (5 + 3)
        expect(cart.shipping_cost)       .to eq 600 * 2
        expect(cart.cod_fee)             .to eq 300
        expect(cart.consumption_tax_rate).to eq 8
        expect(cart.consumption_tax)     .to eq 760
        expect(cart.total)               .to eq 10260
      end
      context "when the total number of cart products is less than 1" do
        it "updates nothing with validation errors" do
          cart.add_product(product1, -8)
          expect(cart.products_num).to eq 8
          expect(cart.errors['purchase_products.num'].size).to be > 0
        end
      end
    end
  end
end
