class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 特定属性のみvalidateする
  def valid_attribute? attribute
    self.class._validators[attribute].each do |validator|
      validator.validate(self)
    end
    self.errors[attribute].blank?
  end

  def invalid_attribute? attribute
    !valid_attribute?(attribute)
  end
end
