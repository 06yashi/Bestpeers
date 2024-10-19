
class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:destroy]

  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id # Assuming you're using Devise for user authentication
    @booking.status = "pending" # Default status before payment

    if @booking.save
      if @booking.total_price.present?
        amount_in_cents = (@booking.total_price * 100).to_i
       
        # Create Stripe checkout session
        session = Stripe::Checkout::Session.create({
          payment_method_types: ['card'],
          line_items: [{
            price_data: {
              currency: 'usd', # Aap apni required currency yahan specify kar sakte hain
              product_data: {
                name: 'Car Booking',
                description: "Booking for Car ID: #{@booking.car_id}",
              },
              unit_amount: amount_in_cents # Stripe expects amount in cents
            },
            quantity: 1,
          }],
          mode: 'payment',
          success_url: checkout_success_url(booking_id: @booking.id),
          cancel_url: checkout_cancel_url(booking_id: @booking.id),
        })
        # Redirect to Stripe checkout page
        redirect_to session.url, allow_other_host: true
      end
    else
      flash[:alert] = "Error creating booking!"
      render :new
    end
  end
  


  def show
    @booking = Booking.find(params[:id])
  end

  def index
    @bookings = Booking.includes(:car).where(user: current_user)
  end

  def destroy
    if refund_payment(@booking.stripe_charge_id)
      @booking.destroy
      flash[:notice] = "Booking was successfully cancelled and refund has been initiated."
      redirect_to bookings_path
    else
      flash[:alert] = "There was an issue with the refund process."
      redirect_to bookings_path
    end
  end

  private

  def refund_payment(stripe_charge_id)
    begin
      charge = Stripe::Charge.retrieve(stripe_charge_id)
      refund = Stripe::Refund.create({
        charge: charge.id
      })
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
