class PurchaseProduct < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  validates :num, presence: true
  validates :num, numericality: {only_integer: true, greater_than: 0, less_than: 100}, if: -> {num.present?}
  validate :validate_current_product

  private

  def validate_current_product
    if self.price != self.product.price
      self.errors.add(:base, "商品「#{self.product.name}」の価格が#{self.price}から#{self.product.price}に変わりました。")
    end
  end
end
