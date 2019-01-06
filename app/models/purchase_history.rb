class PurchaseHistory < Purchase
  enum state: {purchased: 10, delivered: 15}

  has_many :purchase_products, class_name: 'PurchaseProduct', foreign_key: :purchase_id, dependent: :destroy

end
