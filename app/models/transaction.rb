class Transaction < ApplicationRecord
  belongs_to :user
  validates :stripe_charge_id, :amount, :currency, :status, presence: true
end
