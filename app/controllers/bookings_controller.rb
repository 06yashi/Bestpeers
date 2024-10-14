class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [ :destroy]
 

  
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
      UserMailer.booking_notification(current_user).deliver_now  # Pass the User object here
      flash[:notice] = "Booking successfully created!"
  
     
      if @booking.total_price.present?
        amount_in_cents = (@booking.total_price * 100).to_i
        token = params[:stripeToken] 
   
  
      begin
        charge = Stripe::Charge.create(
          source: token,  
          amount: amount_in_cents,
          description: "Payment for Booking ID: #{@booking.id}",
          currency: 'usd'
        )
        @booking.update(stripe_charge_id: charge.id)
        redirect_to @booking, notice: 'Booking was successfully created and payment processed.'
      rescue Stripe::CardError => e
        flash[:error] = e.message
        render :new
      end
    else
      flash.now[:alert] = @booking.errors.full_messages.join(", ")
      render :new
    end
    else
      flash.now[:alert] = @booking.errors.full_messages.join(", ")
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
