class BookingsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
     if current_user.nil?
    redirect_to new_user_session_path, alert: "Please sign in to make a booking."
    return
  end

  @booking = current_user.bookings.build(booking_params)
  if @booking.save
    redirect_to bookings_path, notice: 'Booking created successfully.'
  else
    @cars = Car.all
    render :new
  end
  end

  def index
    @bookings = current_user.bookings
  end

  private

  def booking_params
    params.require(:booking).permit(:car_id, :start_date, :end_date, :total_price, :status)
  end
end
