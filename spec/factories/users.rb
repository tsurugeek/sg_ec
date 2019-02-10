FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end
    password {"hogehoge"}
    confirmed_at {Time.now}

    trait :with_valid_user_shipping_address do
      after(:create) do |user, evaluator|
        user.shipping_address.attributes = attributes_for(:shipping_address)
        user.save
      end
    end

    trait :with_valid_cart_shipping_address do
      after(:create) do |user, evaluator|
        user.cart.shipping_address.attributes = attributes_for(:shipping_address)
        user.cart.save
      end
    end

    factory :user_with_valid_user_shipping_address,          traits: [:with_valid_user_shipping_address]
    factory :user_with_valid_cart_shipping_address,          traits: [:with_valid_cart_shipping_address]
    factory :user_with_valid_user_and_cart_shipping_address, traits: [:with_valid_user_shipping_address, :with_valid_cart_shipping_address]
  end
end
