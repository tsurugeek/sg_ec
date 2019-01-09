require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) do
    user = create(:user_with_valid_user_shipping_address)
    user.cart.add_product(product1, 1)
    user.cart
  end
  let(:product1){create(:product, price: 1000)}

  describe "#fix_products" do
    it "turns state to shipping_address_fixed" do
      expect(cart.state).to eq 'initial'
      expect(cart.fix_products(cart.lock_version)).to be true
      expect(cart.state).to eq 'products_fixed'
    end

    it "raises ActiveRecord::StaleObjectError when the lock_version is old" do
      expect{ cart.fix_products(cart.lock_version - 1) }.to raise_error(ActiveRecord::StaleObjectError)
    end
  end
end
