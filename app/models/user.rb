class User < ApplicationRecord
  has_many :bookings
  has_many :transactions, dependent: :destroy
  

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  

  has_many :cars, dependent: :destroy

  def self.ransackable_associations(_auth_object = nil)
    ['cars', 'bookings']  
  end

  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "stripe_customer_id","transactions_id", "updated_at"]
  end

end
