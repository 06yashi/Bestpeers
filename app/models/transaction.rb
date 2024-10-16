class Transaction < ApplicationRecord
  belongs_to :user

  # Optional: Validations
  validates :stripe_charge_id, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
  validates :status, presence: true
end
