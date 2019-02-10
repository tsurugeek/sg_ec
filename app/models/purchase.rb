class Purchase < ApplicationRecord
  belongs_to :user
  has_one :shipping_address, as: :shippable, dependent: :destroy
  has_many :purchase_products, dependent: :destroy
  has_many :products, through: :purchase_products

  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :purchase_products

  def delivery_scheduled_time
    if self.delivery_scheduled_time_start.present? && self.delivery_scheduled_time_end.present?
      DeliverySchedule.concat_times(self.delivery_scheduled_time_start, self.delivery_scheduled_time_end)
    else
      nil
    end
  end

  def delivery_scheduled_time= value
    self.delivery_scheduled_time_start, self.delivery_scheduled_time_end = DeliverySchedule.split_times(value)
  end
end
