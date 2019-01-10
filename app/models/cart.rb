class Cart < Purchase
  include ActiveSupport::NumberHelper

  enum state: {initial: 0, products_fixed: 2, shipping_address_fixed: 4, purchased: 10}

  validates :products_num, numericality: {only_integer: true, greater_than: 0, less_than: 10_000}, unless: -> {initial?}

  after_create do |purchase|
    purchase.create_shipping_address
  end
  before_validation :validate_state_transition
  before_update :calc_all,                              if: :initial?
  # 価格などの外部リソースの変化はlock_versionでチェックできないので購入確定時にチェックする。
  # しかし、確定するまでの間にもユーザに通知したい seel: #check_external_changes
  before_update :check_external_changes_without_update, if: :purchased?
  after_update :copy_to_purchase_history,               if: :purchased?
  after_update :copy_to_user_shipping_address,          if: :purchased?
  after_update :clear_all,                              if: :purchased?

  def add_product product, num
    self.with_lock do
      catch(:loop_end) do
        self.purchase_products.each do |cart_product|
          if cart_product.product == product
            cart_product.name = product.name
            cart_product.price = product.price
            cart_product.num += num
            cart_product.total = cart_product.price * cart_product.num
            throw :loop_end
          end
        end
        cart_product = self.purchase_products.build({product: product, num: num})
        cart_product.name = product.name
        cart_product.price = product.price
        cart_product.total = cart_product.price * cart_product.num
      end
      self.state = Cart.states[:initial]
      self.save
    end
  end

  def update_product cart_lock_version, product, num
    self.with_lock do
      self.purchase_products.each do |cart_product|
        if cart_product.product == product
          cart_product.num = num
          cart_product.total = cart_product.price * cart_product.num
          break
        end
      end
      self.lock_version = cart_lock_version.to_i
      self.state = Cart.states[:initial]
      self.save
    end
  end

  def remove_product product
    self.with_lock do
      self.purchase_products.each do |cart_product|
        cart_product.mark_for_destruction if cart_product.product == product
      end
      self.state = Cart.states[:initial]
      self.save
    end
  end

  def fix_products lock_version
    self.lock_version = lock_version
    self.update(state: Cart.states[:products_fixed])
  end

  def fix_shipping_address ref_shipping_address: false, save_shipping_address:, delivery_scheduled_date:, delivery_scheduled_time:, lock_version:, shipping_address_attributes:
    cart_attributes = {
      ref_shipping_address:    ref_shipping_address,
      save_shipping_address:   save_shipping_address,
      delivery_scheduled_date: delivery_scheduled_date,
      delivery_scheduled_time: delivery_scheduled_time,
      lock_version:            lock_version,
      shipping_address_attributes: shipping_address_attributes
    }
    self.attributes = cart_attributes

    if self.ref_shipping_address?
      self.shipping_address.copy_from(self.user.shipping_address)
    end
    self.shipping_address.should_be_fixed = true
    self.state = Cart.states[:shipping_address_fixed]
    self.save
  end

  def purchase lock_version
    self.lock_version = lock_version
    self.state = Cart.states[:purchased]
    self.save
  end

  def check_external_changes with_update:
    messages = []

    if self.consumption_tax_rate != ConsumptionTaxRate.current.rate
      messages << "消費税率が#{self.consumption_tax_rate}から#{ConsumptionTaxRate.current.rate}に変更になっているためショッピングカートをご確認ください。"
      self.consumption_tax_rate = ConsumptionTaxRate.current.rate if with_update
    end

    self.purchase_products.each do |purchase_product|
      if purchase_product.product.blank? || purchase_product.product.hidden?
        messages << "商品「#{purchase_product.name}」が販売中止になっているためショッピングカートをご確認ください。"
        purchase_product.mark_for_destruction if with_update
      else
        if purchase_product.name != purchase_product.product.name
          messages << "商品「#{purchase_product.product.name}」の名前が「#{purchase_product.name}」から「#{purchase_product.product.name}」に変更になっているためショッピングカートをご確認ください。"
          purchase_product.name = purchase_product.product.name if with_update
        end
        if purchase_product.price != purchase_product.product.price
          messages << "商品「#{purchase_product.product.name}」の価格が「#{number_to_currency(purchase_product.price)}」から「#{number_to_currency(purchase_product.product.price)}」に変更になっているためショッピングカートをご確認ください。"
          purchase_product.price = purchase_product.product.price if with_update
        end
      end
    end

    if self.shipping_address_fixed? || self.purchased?
      delivery_schedule = DeliverySchedule.new
      if self.delivery_scheduled_date.present?
        deliverable_dates = delivery_schedule.deliverable_dates
        if deliverable_dates.exclude?(self.delivery_scheduled_date)
          messages << "選択された配送日「#{self.delivery_scheduled_date}」が選択可能な配送期間（#{deliverable_dates.first}-#{deliverable_dates.last}）から外れてしまったため再度選択してください。"
          self.delivery_scheduled_date = nil if with_update
        end
      end
      if self.delivery_scheduled_time_start.present? && self.delivery_scheduled_time_end.present?
        deliverable_times = delivery_schedule.deliverable_times
        delivery_scheduled_time = DeliverySchedule.concat_times(self.delivery_scheduled_time_start, self.delivery_scheduled_time_end)
        if deliverable_times.exclude?(self.delivery_scheduled_time)
          messages << "選択された配送時間「#{delivery_scheduled_time}」が選択不可になってしまったため再度選択してください。"
          self.delivery_scheduled_time = nil if with_update
        end
      end
    end

    if with_update
      self.initial!
    end

    if messages.present?
      raise ShouldRestartCartError.new(messages.join("\n"))
    end
  end

  def check_external_changes_without_update
    check_external_changes(with_update: false)
  end


  private

  def validate_state_transition
    if self.state_changed?
      if self.shipping_address_fixed? && self.state_was == 'initial'
        raise ShouldRestartCartError.new('ショッピングカート内の商品を確認してから送付先情報を保存してください。')
      elsif self.purchased? && ['initial', 'products_fixed'].include?(self.state_was)
        raise ShouldRestartCartError.new('送付先情報を保存してから確定してください。')
      end
    end
  end

  def calc_all
    logger.debug{"ショッピングカートを再計算します。(id: #{self.id})"}
    self.products_num, self.subtotal = calc_products_and_sum
    self.shipping_cost = calc_shipping_cost
    self.cod_fee = calc_cod_fee
    self.consumption_tax_rate, self.consumption_tax = calc_consumption_tax
    self.total = calc_total
  end

  def calc_products_and_sum
    num_and_subtotal = [0, 0]
    self.purchase_products.each do |cart_product|
      unless cart_product.marked_for_destruction?
        cart_product.total = cart_product.price * cart_product.num
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
    current_tax = ConsumptionTaxRate.current
    [current_tax.rate, current_tax.calc(self.subtotal.to_i + self.shipping_cost.to_i + self.cod_fee.to_i)]
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
    if self.save_shipping_address?
      logger.debug{"送付先情報をユーザの送付先情報にコピー"}
      self.user.shipping_address.copy_from(self.shipping_address)
      self.user.shipping_address.save!
    end
  end

  def clear_all
    self.purchase_products.destroy_all
    self.shipping_address.clear
    clear
    self.save!
  end

  def clear
    attrs = Cart.new.attributes
    attrs[:state] = Cart.states[:initial]
    attrs.delete('id')
    attrs.delete('user_id')
    attrs.delete('lock_version')
    attrs.delete('created_at')
    attrs.delete('updated_at')
    self.attributes = attrs
  end
end
