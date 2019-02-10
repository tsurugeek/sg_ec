require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){create(:user)}

  describe "after_create" do
    it "creates a new shipping address" do
      expect(user.shipping_address).not_to be_nil
      expect(user.shipping_address.name).to be_nil
      expect(user.shipping_address.postal_code).to be_nil
      expect(user.shipping_address.prefecture).to be_nil
      expect(user.shipping_address.city).to be_nil
      expect(user.shipping_address.address).to be_nil
      expect(user.shipping_address.building).to be_nil
    end
    it "creates a new cart" do
      expect(user.cart).not_to be_nil
    end
  end
end
