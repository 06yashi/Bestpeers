class BookingsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
    @booking = Booking.new(booking_params)
    @cars = Car.all
    @booking.user = current_user
  
  
    if current_user.stripe_customer_id.nil?
      customer = Stripe::Customer.create(email: current_user.email)
      current_user.update(stripe_customer_id: customer.id)
    end
  
    if @booking.save
      flash[:notice] = "Booking successfully created!"
      UserMailer.booking_notification(current_user).deliver_now 
      amount_in_cents = (@booking.total_price * 80).to_i
    
      token = params[:stripeToken] 
  
      begin
        charge = Stripe::Charge.create(
          source: token,  
          amount: amount_in_cents,
          description: "Payment for Booking ID: #{@booking.id}",
          currency: 'usd'
        )
        redirect_to @booking, notice: 'Booking was successfully created and payment processed.'
      rescue Stripe::CardError => e
        flash[:error] = e.message
        render :new
      end
    else
      flash[:alert] = "There was an error in creating your booking."
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def index
    @bookings = current_user.bookings
      
  end

  private

  def booking_params
    params.require(:booking).permit(:car_id, :start_date, :end_date, :status, :total_price)
  end
end
