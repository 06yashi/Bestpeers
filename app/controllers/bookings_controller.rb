class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
    @booking = Booking.new(booking_params)
    @cars = Car.all
    @booking.user = current_user
  
    # Create a Stripe customer if it doesn't exist
    if current_user.stripe_customer_id.nil?
      customer = Stripe::Customer.create(email: current_user.email)
      current_user.update(stripe_customer_id: customer.id)
    end
  
    if @booking.save
      amount_in_cents = (@booking.total_price * 100).to_i
    
      # Add Stripe token here
      token = params[:stripeToken] # New line to get the Stripe token
  
      begin
        charge = Stripe::Charge.create(
          source: token,  # Use token instead of customer ID for card payment
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
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
    puts 'booking sucessful'
  end

  private

  def booking_params
    params.require(:booking).permit(:car_id, :start_date, :end_date, :status, :total_price)
  end
end
