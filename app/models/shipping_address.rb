class ShippingAddress < ApplicationRecord
  belongs_to :shippable, polymorphic: true

  validates :name, length: { maximum: 255 }
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }, if: -> {postal_code.present?}
  validates :prefecture, length: { maximum: 255 }
  validates :city, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :building, length: { maximum: 255 }

end
