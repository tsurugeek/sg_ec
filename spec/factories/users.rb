FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end
    sequence :password do |n|
      "password_#{n}"
    end
    confirmed_at {Time.now}
  end
end
