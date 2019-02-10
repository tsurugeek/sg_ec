class CodFee
  include ActiveModel::Model
  include ActiveModel::Attributes

  private_class_method :new

  def self.current
    new
  end

  def self.calc_current money
    current.calc money
  end

  def calc money
    return nil if money.nil? || money < 0
    case money
    when      0... 10_000 then  300
    when 10_000... 30_000 then  400
    when 30_000...100_000 then  600
    else                       1000
    end
  end
end
