class Product < ApplicationRecord
  mount_uploader :product_image, ProductImageUploader

  has_many :purchase_products, dependent: :restrict_with_exception
  has_many :purchases, through: :purchase_products

  validates :name, presence: true,
                   uniqueness: true
  validates :price, presence: true, if: -> {!hidden}
  validates :price, numericality: {only_integer: true, less_than: 10_000_000}, if: -> {price.present?}
  validates :description, length: { maximum: 500 }
  validates :sort_no, presence: true, if: -> {!hidden}
  validates :sort_no, numericality: {only_integer: true, less_than: 1_000_000}, if: -> {sort_no.present?}
  validates :product_image, presence: true, if: -> {!hidden}
  validates :remove_product_image, exclusion: { in: ["1"], message: "は公開中に実施できません" }, if: -> {!hidden}

  scope :published, -> {where(products: {hidden: false})}

  def self.update_sort_nos ids
    return if ids.blank?

    id_and_sort_no_hash = ids.each_with_index.map{|id, index| [id.to_i, index]}.to_h
    Product.transaction do
      Product.all.each do |product|
        product.update_attribute(:sort_no, id_and_sort_no_hash[product.id].to_i)
      end
    end
  end

  def hidden_name
    if hidden
      "非表示"
    else
      "表示"
    end
  end

end
