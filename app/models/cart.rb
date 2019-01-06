class Cart < Purchase
  enum state: {initial: 0, products_fixed: 2, shipping_address_fixed: 4, purchased: 10}

  after_create do |purchase|
    purchase.create_shipping_address
  end
  before_update :calc_all
  after_update :copy_to_purchase_history, if: :purchased?
  after_update :copy_to_user_shipping_address, if: :purchased?
  after_update :cleanup, if: :purchased?

  def add_product product, num
    self.with_lock do
      catch(:loop_end) do
        self.purchase_products.each do |cart_product|
          if cart_product.product == product
            cart_product.price = product.price
            cart_product.num += num
            cart_product.total = cart_product.price * cart_product.num
            throw :loop_end
          end
        end
        cart_product = self.purchase_products.build({product: product, num: num})
        cart_product.price = product.price
        cart_product.total = cart_product.price * cart_product.num
      end
      self.save
    end
  end

  def update_product product, num
    self.with_lock do
      self.purchase_products.each do |cart_product|
        if cart_product.product == product
          cart_product.price = product.price
          cart_product.num = num
          cart_product.total = cart_product.price * cart_product.num
          break
        end
      end
      self.save
    end
  end

  def remove_product product
    self.with_lock do
      self.purchase_products.each do |cart_product|
        cart_product.mark_for_destruction if cart_product.product == product
      end
      self.save
    end
  end

  def update_shipping_address
    self.state = Cart.states[:shipping_address_fixed]
    if self.ref_shipping_address?
      self.shipping_address.copy_from(self.user.shipping_address)
    end
    self.shipping_address.should_be_fixed = true
    self.save
  end

  def purchase
    self.state = Cart.states[:purchased]
    self.save
  end

  private

  def calc_all
    self.products_num, self.subtotal = calc_products_num_and_subtotal
    self.shipping_cost = calc_shipping_cost
    self.cod_fee = calc_cod_fee
    self.consumption_tax = calc_consumption_tax
    self.total = calc_total
  end

  def calc_products_num_and_subtotal
    num_and_subtotal = [0, 0]
    self.purchase_products.each do |cart_product|
      unless cart_product.marked_for_destruction?
        num_and_subtotal[0] += cart_product.num
        num_and_subtotal[1] += cart_product.total
      end
    end
    num_and_subtotal
  end

  def calc_shipping_cost
    ShippingCost.calc_current(self.products_num)
  end

  def calc_cod_fee
    if self.products_num > 0
      CodFee.calc_current(self.subtotal)
    else
      0
    end
  end

  def calc_consumption_tax
    ConsumptionTaxRate.calc_current(self.subtotal.to_i + self.shipping_cost.to_i + self.cod_fee.to_i)
  end

  def calc_total
    self.subtotal + self.shipping_cost + self.cod_fee + self.consumption_tax
  end

  def copy_to_purchase_history
    # cart -> purchase_history
    attrs = self.dup.attributes
    attrs.delete("type")
    attrs.delete("lock_version")
    purchase_history = PurchaseHistory.new(attrs)
    purchase_history.purchased_at = Time.now
    purchase_history.state = PurchaseHistory.states[:purchased]

    # cart.purchase_products -> purchase_history.purchase_products
    self.purchase_products.each do |purchase_product|
      purchase_history.purchase_products << purchase_product.dup
    end

    # cart.shipping_address -> purchase_history.shipping_address
    purchase_history.shipping_address = self.shipping_address.dup

    purchase_history.save!
  end

  def copy_to_user_shipping_address
    if self.save_shipping_address
      logger.debug{"送付先情報をユーザの送付先情報にコピー"}
      self.user.shipping_address.copy_from(self.shipping_address)
      self.user.shipping_address.save!
    end
  end

  def cleanup
    self.purchase_products.destroy_all
    self.state = Cart.states[:initial]
    self.ref_shipping_address = nil
    self.save_shipping_address = false
    self.shipping_address.clear
    self.save!
  end
end
