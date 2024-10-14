require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:car) { Car.create(name: 'Tesla Model S', model: '2021', price: 79999, fuel_type: 'Electric', seating_capacity: 5, user: user) }
  
  let(:valid_start_date) { Date.today + 1.day }
  let(:valid_end_date) { Date.today + 5.days }
  
  let(:booking) { Booking.new(user: user, car: car, start_date: valid_start_date, end_date: valid_end_date) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(booking).to be_valid
    end

    it 'is not valid without a start date' do
      booking.start_date = nil
      expect(booking).to_not be_valid
      expect(booking.errors[:start_date]).to include("can't be blank")
    end

    it 'is not valid without an end date' do
      booking.end_date = nil
      expect(booking).to_not be_valid
      expect(booking.errors[:end_date]).to include("can't be blank")
    end

    it 'is not valid if end date is before start date' do
      booking.end_date = booking.start_date - 1.day
      expect(booking).to_not be_valid
      expect(booking.errors[:end_date]).to include("must be after the start date")
    end

    it 'is not valid if car is not available' do
      Booking.create(user: user, car: car, start_date: Date.today + 2.days, end_date: Date.today + 6.days)
      expect(booking).to_not be_valid
      expect(booking.errors[:base]).to include("Car is not available from #{booking.start_date} to #{booking.end_date}")
    end

    it 'calculates the total price correctly when saved' do
      booking.save
      days = (booking.end_date - booking.start_date).to_i
      expected_total_price = days * car.price
      expect(booking.total_price).to eq(expected_total_price)
    end

    it 'sets the status to confirmed when saved' do
      booking.save
      expect(booking.status).to eq('confirmed')
    end
  end

  describe 'Associations' do
    it 'belongs to a user' do
      association = Booking.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a car' do
      association = Booking.reflect_on_association(:car)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
