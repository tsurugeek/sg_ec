require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){create(:user)}

  describe "after_save" do
    it "create後、空のshipping_addressが１件作成されていること" do
      expect(user.shipping_address).not_to be_nil
      expect(user.shipping_address.name).to be_nil
      expect(user.shipping_address.postal_code).to be_nil
      expect(user.shipping_address.prefecture).to be_nil
      expect(user.shipping_address.city).to be_nil
      expect(user.shipping_address.address).to be_nil
      expect(user.shipping_address.building).to be_nil
    end
  end
end
