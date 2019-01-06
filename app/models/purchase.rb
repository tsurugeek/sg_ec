class Purchase < ApplicationRecord
  belongs_to :user
  has_one :shipping_address, as: :shippable, dependent: :destroy
  has_many :purchase_products, dependent: :destroy
  has_many :products, through: :purchase_products

  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :purchase_products

end
