class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true

  before_save :set_status_and_calculate_price
  private 
  def set_status_and_calculate_price
    self.status = 'confirmed' 
    
    days = (end_date - start_date).to_i
    self.total_price = days * 100 if days > 0 
  end


  def valid_booking_dates
    return if start_date.nil? || end_date.nil?  
    return unless start_date < end_date
  
    errors.add(:base, 'Start date must be before end date')
  end
end
