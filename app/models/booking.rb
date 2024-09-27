class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true
  # validate :car_must_be_available

  before_save :set_status_and_calculate_price
  private 
  def set_status_and_calculate_price
    self.status = 'confirmed' 
    
    days = (end_date - start_date).to_i
    self.total_price = days * car.price  if days > 0 
  end

  # def car_must_be_available
  #   (start_date..end_date).each do |date|
  #     if car.bookings.where('start_date <= ? AND end_date >= ?', date, date).exists?
  #       errors.add(:base, "Car is not available on #{date}")
  #       break
  #     end
  #   end
  # end


  def valid_booking_dates
    return if start_date.nil? || end_date.nil?  
    return unless start_date < end_date
  
    errors.add(:base, 'Start date must be before end date')
  end
end
