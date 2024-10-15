class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true
  validate :start_date_must_be_before_end_date
  validate :car_must_be_available
  before_save :set_status_and_calculate_price
  

  def self.ransackable_associations(auth_object = nil)
    ["car", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["car_id", "created_at", "end_date", "id", "id_value", "start_date", "status", "stripe_charge_id", "total_price", "updated_at", "user_id"]
  end
  private 

  def set_status_and_calculate_price
    self.status = 'confirmed'
    days = (end_date - start_date).to_i
    if days > 0
      self.total_price = days * car.price
    else
      self.total_price = nil
    end
  end
  def car_must_be_available
    if car.present? && car.bookings.where('start_date < ? AND end_date > ?', end_date, start_date).exists?
      errors.add(:base, "Car is not available from #{start_date} to #{end_date}")
    end
  end

  def start_date_must_be_before_end_date
    return unless start_date.present? && end_date.present?
  
    if start_date >= end_date
      errors.add(:end_date, "must be after the start date.")
    end
  end
  
end
