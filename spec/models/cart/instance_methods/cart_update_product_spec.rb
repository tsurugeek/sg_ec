require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) do
    user = create(:user)
    user.cart.add_product(product1, 1)
    user.cart
  end
  let(:product1){create(:product, price: 1000)}
  let(:product2){create(:product, price: 2000)}

  describe "#update_product" do
    it "raises ActiveRecord::StaleObjectError when cart is old" do
      expect{ cart.update_product(cart.lock_version - 1, product1, 5) }.to raise_error(ActiveRecord::StaleObjectError)
    end

    context "when the cart has the same product as argument's product," do
      it "doesn't occur validation errors" do
        expect(cart.update_product(cart.lock_version, product1, 5)).to be true
        expect(cart.errors.size).to eq 0
      end

      it "updates a num attribute of the purhcase product" do
        expect(cart.update_product(cart.lock_version, product1, 5)).to be true
        expect(cart.purchase_products.first.num).to eq 5
      end

      it "calculates purchase product num and total attributes" do
        expect(cart.update_product(cart.lock_version, product1, 5)).to be true
        expect(cart.purchase_products.first.product_id).to eq product1.id
        expect(cart.purchase_products.first.num)       .to eq 5
        expect(cart.purchase_products.first.total)     .to eq 5000
      end

      it "calculates cart attributes" do
        expect(cart.update_product(cart.lock_version, product1, 5)).to be true
        expect(cart.subtotal)            .to eq 5000
        expect(cart.products_num)        .to eq 5
        expect(cart.shipping_cost)       .to eq 600
        expect(cart.cod_fee)             .to eq 300
        expect(cart.consumption_tax_rate).to eq 8
        expect(cart.consumption_tax)     .to eq 472
        expect(cart.total)               .to eq 6372
      end

      context "when the argument num is less than 1" do
        it "updates nothing with validation errors" do
          expect(cart.update_product(cart.lock_version, product1, 0)).to be false
          expect(cart.errors['purchase_products.num'].size).to be > 0
          expect(cart.products_num).to eq 1
        end
      end
    end

    context "when the cart doesn't has the same product as argument's product," do
      it "doesn't occur validation errors" do
        expect(cart.update_product(cart.lock_version, product2, 5)).to be true
        expect(cart.errors.size).to eq 0
      end

      it "doesn't updates a num attribute of the purchase product" do
        expect(cart.update_product(cart.lock_version, product2, 5)).to be true
        expect(cart.purchase_products.size).to eq 1
      end

      it "calculates cart attributes" do
        cart_old = cart.dup
        expect(cart.update_product(cart.lock_version, product2, 5)).to be true
        expect(cart.products_num)        .to eq cart_old.products_num
        expect(cart.subtotal)            .to eq cart_old.subtotal
        expect(cart.products_num)        .to eq cart_old.products_num
        expect(cart.shipping_cost)       .to eq cart_old.shipping_cost
        expect(cart.cod_fee)             .to eq cart_old.cod_fee
        expect(cart.consumption_tax_rate).to eq cart_old.consumption_tax_rate
        expect(cart.consumption_tax)     .to eq cart_old.consumption_tax
        expect(cart.total)               .to eq cart_old.total
      end
    end
  end
end
