FactoryBot.define do
  factory :admin do
    sequence :email do |n|
      "admin_#{n}@example.com"
    end
    sequence :password do |n|
      "password_#{n}"
    end
  end
end
