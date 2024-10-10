class Car < ApplicationRecord
  belongs_to :user, optional: true
  has_many :bookings

  enum fuel_type: { petrol: 'petrol', diesel: 'diesel', electric: 'electric' }

  validates :name, :model, :price, :fuel_type, :seating_capacity, presence: true

  validate :price_must_be_positive
  
  has_one_attached :photo
  private

  def price_must_be_positive
    errors.add(:price, 'must be greater than 0') if price.present? && price <= 0
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at fuel_type id id_value model name price seating_capacity updated_at user_id]
  end
end
