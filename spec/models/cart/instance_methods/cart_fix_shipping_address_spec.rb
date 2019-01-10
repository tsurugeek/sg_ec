require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) do
    user = create(:user_with_valid_user_shipping_address)
    user.cart.add_product(product1, 1)
    user.cart.fix_products(user.cart.lock_version)
    user.cart
  end
  let(:args) do
    a = {
      # ref_shipping_address: true,
      save_shipping_address: false,
      delivery_scheduled_date: nil,
      delivery_scheduled_time: nil,
      # lock_version: cart.lock_version,
    }
    a[:shipping_address_attributes] = attributes_for(:shipping_address)
    # args[:shipping_address_attributes][:id] = cart.shipping_address.id
    a
  end
  let(:product1){create(:product, price: 1000)}

  describe "#fix_shipping_address" do
    it "turns state to shipping_address_fixed" do
      args[:ref_shipping_address] = true
      args[:lock_version] = cart.lock_version
      args[:shipping_address_attributes][:id] = cart.shipping_address.id
      expect(cart.state).to eq 'products_fixed'
      expect(cart.fix_shipping_address(args)).to be true
      expect(cart.state).to eq 'shipping_address_fixed'
    end

    it "raises ActiveRecord::StaleObjectError when the lock_version is old" do
      args[:ref_shipping_address] = true
      args[:lock_version] = cart.lock_version - 1
      args[:shipping_address_attributes][:id] = cart.shipping_address.id
      expect{ cart.fix_shipping_address(args) }.to raise_error(ActiveRecord::StaleObjectError)
    end

    it "raises ShouldRestartCartError when the state is initial" do
      cart.initial!
      args[:ref_shipping_address] = true
      args[:lock_version] = cart.lock_version
      args[:shipping_address_attributes][:id] = cart.shipping_address.id
      expect{ cart.fix_shipping_address(args) }.to raise_error(ShouldRestartCartError)
    end

    context "when USER's shipping_address is available," do
      context "when ARGS' shipping_address is available," do
        context "when ARG ref_shipping_address is TRUE," do
          it "saves with USER's shipping address" do
            args[:ref_shipping_address] = true
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id

            expect(cart.fix_shipping_address(args)).to be true
            expect(cart.errors.size).to eq 0
            expect(cart.shipping_address.name).to        eq cart.user.shipping_address.name
            expect(cart.shipping_address.postal_code).to eq cart.user.shipping_address.postal_code
            expect(cart.shipping_address.prefecture).to  eq cart.user.shipping_address.prefecture
            expect(cart.shipping_address.city).to        eq cart.user.shipping_address.city
            expect(cart.shipping_address.address).to     eq cart.user.shipping_address.address
            expect(cart.shipping_address.building).to    eq cart.user.shipping_address.building
          end
        end

        context "when ARG ref_shipping_address is FALSE," do
          it "saves with ARGS's shipping address" do
            args[:ref_shipping_address] = false
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id

            expect(cart.fix_shipping_address(args)).to be true
            expect(cart.errors.size).to eq 0
            expect(cart.shipping_address.name).to        eq args[:shipping_address_attributes][:name]
            expect(cart.shipping_address.postal_code).to eq args[:shipping_address_attributes][:postal_code]
            expect(cart.shipping_address.prefecture).to  eq args[:shipping_address_attributes][:prefecture]
            expect(cart.shipping_address.city).to        eq args[:shipping_address_attributes][:city]
            expect(cart.shipping_address.address).to     eq args[:shipping_address_attributes][:address]
            expect(cart.shipping_address.building).to    eq args[:shipping_address_attributes][:building]
          end
        end
      end

      context "when ARGS' shipping_address is NOT available," do
        context "when ARG ref_shipping_address is TRUE," do
          it "saves with USER's shipping address" do
            args[:ref_shipping_address] = true
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id
            args[:shipping_address_attributes][:name] = nil

            expect(cart.fix_shipping_address(args)).to be true
            expect(cart.errors.size).to eq 0
            expect(cart.shipping_address.name).to        eq cart.user.shipping_address.name
            expect(cart.shipping_address.postal_code).to eq cart.user.shipping_address.postal_code
            expect(cart.shipping_address.prefecture).to  eq cart.user.shipping_address.prefecture
            expect(cart.shipping_address.city).to        eq cart.user.shipping_address.city
            expect(cart.shipping_address.address).to     eq cart.user.shipping_address.address
            expect(cart.shipping_address.building).to    eq cart.user.shipping_address.building
          end
        end

        context "when ARG ref_shipping_address is FALSE," do
          it "dosen't save with invalid error" do
            args[:ref_shipping_address] = false
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id
            args[:shipping_address_attributes][:name] = nil

            expect(cart.fix_shipping_address(args)).to be false
            expect(cart.errors[:'shipping_address.name'].size).to be > 0
          end
        end
      end
    end

    context "when USER's shipping_address is NOT available," do
      context "when ARGS' shipping_address is available," do
        context "when ARG ref_shipping_address is TRUE," do
          it "saves with USER's shipping address" do
            cart.user.shipping_address.update(name: nil)
            args[:ref_shipping_address] = true
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id

            expect(cart.fix_shipping_address(args)).to be false
            expect(cart.errors[:'shipping_address.name'].size).to be > 0
          end
        end

        context "when ARG ref_shipping_address is FALSE," do
          it "saves with ARGS's shipping address" do
            cart.user.shipping_address.update(name: nil)
            args[:ref_shipping_address] = false
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id

            expect(cart.fix_shipping_address(args)).to be true
            expect(cart.errors.size).to eq 0
            expect(cart.shipping_address.name).to        eq args[:shipping_address_attributes][:name]
            expect(cart.shipping_address.postal_code).to eq args[:shipping_address_attributes][:postal_code]
            expect(cart.shipping_address.prefecture).to  eq args[:shipping_address_attributes][:prefecture]
            expect(cart.shipping_address.city).to        eq args[:shipping_address_attributes][:city]
            expect(cart.shipping_address.address).to     eq args[:shipping_address_attributes][:address]
            expect(cart.shipping_address.building).to    eq args[:shipping_address_attributes][:building]
          end
        end
      end

      context "when ARGS' shipping_address is NOT available," do
        context "when ARG ref_shipping_address is TRUE," do
          it "saves with USER's shipping address" do
            cart.user.shipping_address.update(name: nil)
            args[:ref_shipping_address] = true
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id
            args[:shipping_address_attributes][:name] = nil

            expect(cart.fix_shipping_address(args)).to be false
            expect(cart.errors[:'shipping_address.name'].size).to be > 0
          end
        end

        context "when ARG ref_shipping_address is FALSE," do
          it "dosen't save with invalid error" do
            cart.user.shipping_address.update(name: nil)
            args[:ref_shipping_address] = false
            args[:lock_version] = cart.lock_version
            args[:shipping_address_attributes][:id] = cart.shipping_address.id
            args[:shipping_address_attributes][:name] = nil

            expect(cart.fix_shipping_address(args)).to be false
            expect(cart.errors[:'shipping_address.name'].size).to be > 0
          end
        end
      end
    end
  end
end
