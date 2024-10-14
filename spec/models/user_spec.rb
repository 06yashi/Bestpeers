# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
   
      User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')

     
      expect(user).to_not be_valid
    end

    it 'is valid with a unique email' do
      
      User.create(email: 'unique@example.com', password: 'password', password_confirmation: 'password')

      
      expect(user).to be_valid
    end
  end

  context 'associations' do
    it 'should have many bookings' do
      association = User.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)
    end

    it 'should have many cars' do
      association = User.reflect_on_association(:cars)
      expect(association.macro).to eq(:has_many)
    end

    it 'should have dependent destroy for cars' do
      association = User.reflect_on_association(:cars)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  context 'devise modules' do
    it 'validates email format' do
      
      user.email = 'invalid_email'
      expect(user).to_not be_valid
    end
  end

  
end
