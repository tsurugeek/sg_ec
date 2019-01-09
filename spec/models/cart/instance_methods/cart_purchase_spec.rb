require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) do
    user = create(:user_with_valid_user_shipping_address)
    user.cart.add_product(product1, 1)
    user.cart.fix_products(user.cart.lock_version)
    user.cart.fix_shipping_address(
      ref_shipping_address: false,
      save_shipping_address: false,
      delivery_scheduled_date: DeliverySchedule.new.deliverable_dates.first,
      delivery_scheduled_time: DeliverySchedule.new.deliverable_times.first,
      lock_version: user.cart.lock_version,
      shipping_address_attributes: attributes_for(:shipping_address).merge(id: user.cart.shipping_address.id)
    )
    user.cart
  end
  let(:product1){create(:product, price: 1000)}

  describe "#purchase" do
    it "copies cart shipping address to user shipping address when cart.save_shipping_address is TRUE" do
      cart.save_shipping_address = true
      cart.save

      # purchase実行後、cart.shipping_addressはクリアされてしまうので一時保存
      old_cart_shipping_address = cart.shipping_address.dup

      expect(cart.purchase(cart.lock_version)).to be true
      expect(cart.user.shipping_address.name)       .to eq old_cart_shipping_address.name
      expect(cart.user.shipping_address.postal_code).to eq old_cart_shipping_address.postal_code
      expect(cart.user.shipping_address.prefecture) .to eq old_cart_shipping_address.prefecture
      expect(cart.user.shipping_address.city)       .to eq old_cart_shipping_address.city
      expect(cart.user.shipping_address.address)    .to eq old_cart_shipping_address.address
      expect(cart.user.shipping_address.building)   .to eq old_cart_shipping_address.building
    end

    it "doesn't copy cart shipping address to user shipping address when cart.save_shipping_address is FALSE" do

      # purchase実行後、cart.shipping_addressはクリアされてしまうので一時保存
      old_cart_shipping_address = cart.shipping_address.dup
      old_user_shipping_address = cart.user.shipping_address.dup

      expect(cart.purchase(cart.lock_version)).to be true
      expect(cart.user.shipping_address.name)       .not_to eq old_cart_shipping_address.name
      expect(cart.user.shipping_address.postal_code).not_to eq old_cart_shipping_address.postal_code
      expect(cart.user.shipping_address.prefecture) .not_to eq old_cart_shipping_address.prefecture
      expect(cart.user.shipping_address.city)       .not_to eq old_cart_shipping_address.city
      expect(cart.user.shipping_address.address)    .not_to eq old_cart_shipping_address.address
      expect(cart.user.shipping_address.building)   .not_to eq old_cart_shipping_address.building
      expect(cart.user.shipping_address.name)       .to eq old_user_shipping_address.name
      expect(cart.user.shipping_address.postal_code).to eq old_user_shipping_address.postal_code
      expect(cart.user.shipping_address.prefecture) .to eq old_user_shipping_address.prefecture
      expect(cart.user.shipping_address.city)       .to eq old_user_shipping_address.city
      expect(cart.user.shipping_address.address)    .to eq old_user_shipping_address.address
      expect(cart.user.shipping_address.building)   .to eq old_user_shipping_address.building
    end

    it "turns state to initial" do
      expect(cart.purchase(cart.lock_version)).to be true
      expect(cart.state).to eq 'initial'
    end

    it "copies the cart to a new puchase history and clear the cart and shipping address" do
      old_cart = cart.dup
      old_cart_purchase_product = cart.purchase_products.first.dup
      old_cart_shipping_address = cart.shipping_address.dup

      expect { cart.purchase(cart.lock_version) }.to change { Purchase.count }.by(1)

      expect(PurchaseHistory.last.id                           ).not_to eq old_cart.id
      expect(PurchaseHistory.last.user_id                      ).to eq old_cart.user_id
      expect(PurchaseHistory.last.type                         ).to eq 'PurchaseHistory'
      expect(PurchaseHistory.last.state                        ).to eq 'purchased'
      expect(PurchaseHistory.last.purchased_at                 ).not_to be_nil
      expect(PurchaseHistory.last.delivered_at                 ).to be_nil
      expect(PurchaseHistory.last.subtotal                     ).to eq old_cart.subtotal
      expect(PurchaseHistory.last.products_num                 ).to eq old_cart.products_num
      expect(PurchaseHistory.last.shipping_cost                ).to eq old_cart.shipping_cost
      expect(PurchaseHistory.last.cod_fee                      ).to eq old_cart.cod_fee
      expect(PurchaseHistory.last.consumption_tax_rate         ).to eq old_cart.consumption_tax_rate
      expect(PurchaseHistory.last.consumption_tax              ).to eq old_cart.consumption_tax
      expect(PurchaseHistory.last.total                        ).to eq old_cart.total
      expect(PurchaseHistory.last.delivery_scheduled_date      ).to eq old_cart.delivery_scheduled_date
      expect(PurchaseHistory.last.delivery_scheduled_time_start).to eq old_cart.delivery_scheduled_time_start
      expect(PurchaseHistory.last.delivery_scheduled_time_end  ).to eq old_cart.delivery_scheduled_time_end
      expect(PurchaseHistory.last.ref_shipping_address         ).to eq old_cart.ref_shipping_address
      expect(PurchaseHistory.last.save_shipping_address        ).to eq old_cart.save_shipping_address
      expect(PurchaseHistory.last.lock_version                 ).not_to eq old_cart.lock_version
      expect(PurchaseHistory.last.created_at                   ).not_to eq old_cart.created_at
      expect(PurchaseHistory.last.updated_at                   ).not_to eq old_cart.updated_at

      expect(PurchaseHistory.last.purchase_products.first.id         ).not_to eq old_cart_purchase_product.id
      expect(PurchaseHistory.last.purchase_products.first.purchase_id).not_to eq old_cart_purchase_product.purchase_id
      expect(PurchaseHistory.last.purchase_products.first.product_id ).to eq old_cart_purchase_product.product_id
      expect(PurchaseHistory.last.purchase_products.first.name       ).to eq old_cart_purchase_product.name
      expect(PurchaseHistory.last.purchase_products.first.price      ).to eq old_cart_purchase_product.price
      expect(PurchaseHistory.last.purchase_products.first.num        ).to eq old_cart_purchase_product.num
      expect(PurchaseHistory.last.purchase_products.first.total      ).to eq old_cart_purchase_product.total
      expect(PurchaseHistory.last.purchase_products.first.created_at ).not_to eq old_cart_purchase_product.created_at
      expect(PurchaseHistory.last.purchase_products.first.updated_at ).not_to eq old_cart_purchase_product.updated_at

      expect(PurchaseHistory.last.shipping_address.id            ).not_to eq old_cart_shipping_address.id
      expect(PurchaseHistory.last.shipping_address.shippable_id  ).not_to eq old_cart_shipping_address.shippable_id
      expect(PurchaseHistory.last.shipping_address.shippable_type).to eq old_cart_shipping_address.shippable_type
      expect(PurchaseHistory.last.shipping_address.name          ).to eq old_cart_shipping_address.name
      expect(PurchaseHistory.last.shipping_address.postal_code   ).to eq old_cart_shipping_address.postal_code
      expect(PurchaseHistory.last.shipping_address.prefecture    ).to eq old_cart_shipping_address.prefecture
      expect(PurchaseHistory.last.shipping_address.city          ).to eq old_cart_shipping_address.city
      expect(PurchaseHistory.last.shipping_address.address       ).to eq old_cart_shipping_address.address
      expect(PurchaseHistory.last.shipping_address.building      ).to eq old_cart_shipping_address.building
      expect(PurchaseHistory.last.shipping_address.created_at    ).not_to eq old_cart_shipping_address.created_at
      expect(PurchaseHistory.last.shipping_address.updated_at    ).not_to eq old_cart_shipping_address.updated_at
    end

    it "raises ActiveRecord::StaleObjectError when the cart is old" do
      expect{ cart.purchase(cart.lock_version - 1) }.to raise_error(ActiveRecord::StaleObjectError)
    end

    it "raises ShouldRestartCartError when the state is initial" do
      cart.initial!
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the state is products_fixed" do
      cart.products_fixed!
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the current consumption tax rate has been changed" do
      cart # <- 税率変更の前にロードしたいから
      current_rate = ConsumptionTaxRate.current.rate

      # 一時的に税率を変更する
      ConsumptionTaxRate.class_eval { class << self; self; end }.class_eval do
        define_method(:current) do
          new(rate: current_rate + 2)
        end
      end
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
      ConsumptionTaxRate.class_eval { class << self; self; end }.class_eval do
        define_method(:current) do
          new(rate: current_rate)
        end
      end
    end

    it "raises ShouldRestartCartError when the product has been destroyed" do
      cart # <- 削除の前にロードしたいから
      product1.destroy!
      cart.reload
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the product has been hidden" do
      cart # <- 変更前にロードしたいから
      product1.hidden = true
      product1.save!
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the current product name has been changed" do
      cart # <- 名前変更の前にロードしたいから
      product1.name += "change"
      product1.save!
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the current product price has been changed" do
      cart # <- 価格変更の前にロードしたいから
      product1.price += 1
      product1.save!
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
    end

    it "raises ShouldRestartCartError when the delivery scheduled date has been out of choises" do
      cart # <- 可能日の変更の前にロードしたいから
      min = DeliverySchedule::MIN_AVAILABLE_BUSINESS_DAY

      # 一時的に可能日を変更する
      DeliverySchedule.class_eval do
        ::DeliverySchedule::MIN_AVAILABLE_BUSINESS_DAY = min + 1
      end
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
      DeliverySchedule.class_eval do
        ::DeliverySchedule::MIN_AVAILABLE_BUSINESS_DAY = min
      end
    end

    it "raises ShouldRestartCartError when the delivery scheduled time has been out of choises" do
      cart # <- 可能日の変更の前にロードしたいから
      deliverable_splitted_times = DeliverySchedule.new.deliverable_splitted_times

      # 一時的に可能日を変更する
      DeliverySchedule.class_eval do
        define_method(:deliverable_splitted_times) do
          deliverable_splitted_times.dup.slice(1, deliverable_splitted_times.size - 1)
        end
      end
      expect{ cart.purchase(cart.lock_version) }.to raise_error(ShouldRestartCartError)
      DeliverySchedule.class_eval do
        define_method(:deliverable_splitted_times) do
          deliverable_splitted_times.dup
        end
      end
    end

  end
end
