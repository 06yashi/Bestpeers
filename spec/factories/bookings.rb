FactoryBot.define do
    factory :booking do
      start_date { Date.today + 1.day }
      end_date { Date.today + 5.days }
      association :user
      association :car
      status { 'confirmed' }
  
      after(:build) do |booking|
        days = (booking.end_date - booking.start_date).to_i
        booking.total_price = days * booking.car.price
      end
    end
  end
  