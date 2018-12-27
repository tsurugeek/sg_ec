class Product < ApplicationRecord

  validates :name, presence: true,
                   uniqueness: true
  validates :price, presence: true, if: -> {!hidden}
  validates :price, numericality: {only_integer: true, less_than: 10_000_000}, if: -> {price.present?}
  validates :description, length: { maximum: 500 }
  validates :sort_no, presence: true, if: -> {!hidden}
  validates :sort_no, numericality: {only_integer: true, less_than: 1_000_000}, if: -> {sort_no.present?}

end
