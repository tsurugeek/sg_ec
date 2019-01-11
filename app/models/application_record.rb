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

  # ActiveRecord::StaleObjectErrorを無視したい場合に使う（悲観的ロックを使ってもいいが、リロードしない分こちらの方が速い）
  # https://apidock.com/rails/ActiveRecord/Persistence/reload
  def with_optimistic_retry(raise_error_if_not_founcd)
    begin
      yield
    rescue ActiveRecord::StaleObjectError
      begin
        # Reload lock_version in particular.
        reload
      rescue ActiveRecord::RecordNotFound => e
        # If the record is gone there is nothing to do.
        raise e if raise_error_if_not_founcd
      else
        retry
      end
    end
  end

  def joined_messages
     self.errors.full_messages.join("\n")
  end
end
