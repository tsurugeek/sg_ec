class ShippingAddress < ApplicationRecord
  belongs_to :shippable, polymorphic: true

  attribute :should_be_fixed, :boolean, default: false

  validates :name,        presence: true, if: :should_be_fixed?
  validates :postal_code, presence: true, if: :should_be_fixed?
  validates :prefecture,  presence: true, if: :should_be_fixed?
  validates :city,        presence: true, if: :should_be_fixed?
  validates :address,     presence: true, if: :should_be_fixed?

  validates :name, length: { maximum: 255 }
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }, if: -> {postal_code.present?}
  validates :prefecture, length: { maximum: 255 }
  validates :city, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :building, length: { maximum: 255 }

  def available?
    self.name.present? \
      && self.postal_code.present? \
      && self.prefecture.present? \
      && self.city.present? \
      && self.address.present?
  end

  def copy_from other_shipping_address
    self.attributes = other_shipping_address.slice('name', 'postal_code', 'prefecture', 'city', 'address', 'building')
  end

  def clear
    self.name = nil
    self.postal_code = nil
    self.prefecture = nil
    self.city = nil
    self.address = nil
    self.building = nil
  end
end
