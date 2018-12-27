FactoryBot.define do
  factory :product do
    sequence(:name) {|n|"product name #{n}"}
    sequence(:price) {|n| n * 100}
    sequence(:description) {|n| "product description #{n}"}
    hidden { false }
    sequence(:sort_no) {|n| n * 10}
  end
end
