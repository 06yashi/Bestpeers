class Car < ApplicationRecord
  belongs_to :user, optional: true
  has_many :bookings
  enum fuel_type: { petrol: 'petrol', diesel: 'diesel', electric: 'electric' }
  validates :name, :model, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :fuel_type, presence: true
  validates :seating_capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  has_one_attached :photo

 
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at fuel_type id model name price seating_capacity updated_at user_id]
  end
end
