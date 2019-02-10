FactoryBot.define do
  factory :purchase do
    user_id { 1 }
    state { 1 }
    purchased_at { "2019-01-02 17:13:39" }
    delivered_at { "2019-01-02 17:13:39" }
    subtotal { 1 }
    shipping_cost { 1 }
    cod_fee { 1 }
    consumption_tax_rate { 1 }
    consumption_tax { 1 }
    total { 1 }
  end
end
