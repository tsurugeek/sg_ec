require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user){create(:user)}
  let(:cart){user.cart}
  let(:product1){create(:product, price: 1000)}
  let(:product2){create(:product, price: 2000)}
  let(:product3){create(:product, price: 3000)}

  describe "after_create" do
    it "creates a new shipping address" do
      expect(user.cart.shipping_address).not_to be_nil
    end
    it "doesn't create any new purchase product" do
      expect(user.cart.purchase_products.size).to eq 0
    end
  end
end
