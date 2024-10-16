FactoryBot.define do
  factory :transaction do
    user { nil }
    stripe_charge_id { "MyString" }
    amount { 1 }
    currency { "MyString" }
    status { "MyString" }
  end
end
