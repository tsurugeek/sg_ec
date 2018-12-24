FactoryBot.define do
  factory :shipping_address do
    user_id { 1 }
    name { "MyString" }
    postal_code { "MyString" }
    prefecture { "MyString" }
    city { "MyString" }
    address { "MyString" }
    building { "MyString" }
  end
end
