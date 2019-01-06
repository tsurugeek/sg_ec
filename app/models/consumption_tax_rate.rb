class ConsumptionTaxRate
  include ActiveModel::Model
  include ActiveModel::Attributes

  private_class_method :new

  attribute :rate, :integer

  def self.current
    new(rate: 8)
  end

  def self.calc_current money
    current.calc money
  end

  def calc money
    return nil if money.nil?
    (money * self.rate.to_f / 100).floor
  end
end
