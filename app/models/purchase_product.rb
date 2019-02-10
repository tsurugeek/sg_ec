class PurchaseProduct < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  validates :num, presence: true
  validates :num, numericality: {only_integer: true, greater_than: 0, less_than: 100}, if: -> {num.present?}

  private

end
