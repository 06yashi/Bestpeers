# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: user.email)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is not valid when password and password_confirmation do not match' do
      user.password_confirmation = 'different_password'
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context 'associations' do
    it 'has many bookings' do
      association = User.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)
    end
  end
end
