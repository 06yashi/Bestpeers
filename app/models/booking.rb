class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true
  # validate :end_date_after_start_date
  # validate :car_must_be_available
  # # validate :valid_booking_dates 
  before_save :set_status_and_calculate_price
  # # before_save :start_date_must_be_before_end_date

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
      self.total_price = nil # Agar dates invalid hain, toh total_price ko nil set karein
    end
  end

  def car_must_be_available
    if car.bookings.where('start_date < ? AND end_date > ?', end_date, start_date).exists?
      errors.add(:base, "Car is not available from #{start_date} to #{end_date}")
    end
  end


  def valid_booking_dates
    return if start_date.nil? || end_date.nil?  
    return unless start_date < end_date
  
    errors.add(:base, 'Start date must be before end date')
  end

  def start_date_must_be_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:start_date, "must be before end date")
    end
  end 
  
  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end