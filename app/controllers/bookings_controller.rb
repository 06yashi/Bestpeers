
class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:destroy]

  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id 
    @booking.status = "pending" 
  
    if @booking.save
      if @booking.total_price.present?
        amount_in_cents = (@booking.total_price * 100).to_i
        
        session = Stripe::Checkout::Session.create({
          payment_method_types: ['card'],
          line_items: [{
            price_data: {
              currency: 'inr',
              product_data: {
                name: 'Car Booking',
                description: "Booking for Car ID: #{@booking.car_id}",
              },
              unit_amount: amount_in_cents,
            },
            quantity: 1,
          }],
          mode: 'payment',
          payment_intent_data: {
            setup_future_usage: "off_session"
          },
          success_url: checkout_success_url(booking_id: @booking.id),
          cancel_url: checkout_cancel_url(booking_id: @booking.id),
        })
        
        @booking.update!(stripe_charge_id: session.id)
  
        redirect_to session.url, allow_other_host: true
      else
        flash[:alert] = "Total price not available!"
        render :new
      end
    else
      flash.now[:alert] 
      @cars = Car.all 
      render :new
    end
  end


  def destroy
    if refund_payment(@booking.stripe_charge_id)
      @booking.transactions.destroy_all
      @booking.destroy
      flash[:notice] = "Booking was successfully cancelled and refund has been initiated."
      redirect_to bookings_path
    else
      flash[:alert] = "There was an issue with the refund process."
      redirect_to bookings_path
    end
  end
  


  def show
    @booking = Booking.find(params[:id])
  end

  def index
   
  @bookings = Booking.includes(:car).where(user: current_user, status: 'paid')
  @bookings = Booking.includes(:car).where(user: current_user)
  @cars = Car.all
  @start_date = params[:start_date] # Get start date from params
  @end_date = params[:end_date]
  end

 

  private

  def refund_payment(stripe_charge_id)
    begin
      # Fetch the Stripe c checkout_session.payment_intentharge object
      checkout_session = Stripe::Checkout::Session.retrieve(stripe_charge_id)
       payment_intent = checkout_session.payment_intent
      # Initiate the refund process
      refund = Stripe::Refund.create({
        payment_intent: payment_intent
      })

      # Check if refund succeeded
      return true if refund.status == 'succeeded'

    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error while refunding charge: #{e.message}"
      return false
    end
  end



  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:car_id, :start_date, :end_date, :status, :total_price, :stripe_charge_id)
  end
end