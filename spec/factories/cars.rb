FactoryBot.define do
    factory :car do
      name { 'Tesla Model S' }
      model { '2021' }
      price { 79999 }
      fuel_type { 'electric' }
      seating_capacity { 5 }
      association :user
    end
end
  