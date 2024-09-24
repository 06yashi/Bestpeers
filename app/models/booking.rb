class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, presence: true
  validate :valid_booking_dates

  def valid_booking_dates
    return unless start_date >= end_date

    errors.add(:base, 'Start date must be before end date')
  end
end
