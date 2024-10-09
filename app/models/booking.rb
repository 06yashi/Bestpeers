class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true
  # validates :total_price, presence: true
   validate :car_must_be_available

  before_save :set_status_and_calculate_price
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
end
