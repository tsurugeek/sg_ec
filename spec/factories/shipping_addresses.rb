FactoryBot.define do
  factory :shipping_address do
    sequence(:name) {|n| "shipping_address name #{n}"}
    postal_code { "000-0000" }
    sequence(:prefecture) {|n| "shipping_address prefecture #{n}"}
    sequence(:city) {|n| "shipping_address city #{n}"}
    sequence(:address) {|n| "shipping_address address #{n}"}
    sequence(:building) {|n| "shipping_address building #{n}"}
  end
end
