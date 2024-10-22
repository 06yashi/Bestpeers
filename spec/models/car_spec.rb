require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:user) { create(:user) }
  let(:car) { build(:car, user: user) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(car).to be_valid
    end

    it 'is not valid without a name' do
      car.name = nil
      expect(car).to_not be_valid
      expect(car.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a model' do
      car.model = nil
      expect(car).to_not be_valid
      expect(car.errors[:model]).to include("can't be blank")
    end

    it 'is not valid without a price' do
      car.price = nil
      expect(car).to_not be_valid
      expect(car.errors[:price]).to include("can't be blank")
    end

    it 'is not valid with a non-numeric price' do
      car.price = 'abc'
      expect(car).to_not be_valid
      expect(car.errors[:price]).to include("is not a number")
    end

    it 'is not valid with a price less than or equal to zero' do
      car.price = 0
      expect(car).to_not be_valid
      expect(car.errors[:price]).to include("must be greater than 0")
    end

    it 'is not valid without a fuel type' do
      car.fuel_type = nil
      expect(car).to_not be_valid
      expect(car.errors[:fuel_type]).to include("can't be blank")
    end

    it 'is not valid without a seating capacity' do
      car.seating_capacity = nil
      expect(car).to_not be_valid
      expect(car.errors[:seating_capacity]).to include("can't be blank")
    end

    it 'is not valid with a non-integer seating capacity' do
      car.seating_capacity = 4.5
      expect(car).to_not be_valid
      expect(car.errors[:seating_capacity]).to include("must be an integer")
    end

    it 'is not valid with a seating capacity less than or equal to zero' do
      car.seating_capacity = 0
      expect(car).to_not be_valid
      expect(car.errors[:seating_capacity]).to include("must be greater than 0")
    end
  end

  context 'associations' do
    it 'belongs to a user' do
      association = Car.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
