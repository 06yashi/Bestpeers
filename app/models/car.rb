class Car < ApplicationRecord
  belongs_to :user
  has_many :bookings
  validates :name, presence: true
  validates :model, presence: true
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value model name updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end
end
