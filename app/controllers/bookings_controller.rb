class BookingsController < ApplicationController
  def new 
    @booking = Booking.new
    @cars = Car.all 
   
  end

  def create
     
    @booking = Booking.new(booking_params)
    @cars = Car.all 
  
    @booking.user = current_user
    if @booking.save!
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new
    end
  end
  def show
    @booking = Booking.find(params[:id])
    puts "booking sucessful"
  end

  private

  def booking_params
    params.require(:booking).permit(:car_id, :start_date, :end_date, :status, :total_price)
  end
end
