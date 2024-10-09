class User < ApplicationRecord
  has_many :bookings

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :stripe_customer_id

  has_many :cars, dependent: :destroy

  def self.ransackable_associations(_auth_object = nil)
    ['cars', 'bookings']  # Add 'bookings' here
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password id id_value remember_created_at reset_password_sent_at
       reset_password_token updated_at bookings_total_price bookings_status]  # Add booking attributes if needed
  end
end
