class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  validates :stripe_charge_id, :amount, :currency, :status, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "created_at", "currency", "id", "id_value", "status", "stripe_charge_id", "updated_at", "user_id"]
  end


end
