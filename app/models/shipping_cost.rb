class ShippingCost
  include ActiveModel::Model
  include ActiveModel::Attributes

  private_class_method :new

  attribute :num, :integer
  attribute :cost, :integer

  def self.current
    new(num: 5, cost: 600)
  end

  def self.calc_current products_num
    current.calc products_num
  end

  def calc products_num
    return nil if products_num.nil?
    (products_num / self.num.to_f).ceil * self.cost
  end
end
