class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:destroy]

  def new
    @booking = Booking.new
    @cars = Car.all
  end

  def create
    @booking = Booking.new(booking_params)
    @cars = Car.all
    @booking.user = current_user
    
    # Check and create Stripe customer if not already exists
    if current_user.stripe_customer_id.nil?
      if current_user.email.present? && current_user.email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
        begin
          customer = Stripe::Customer.create(email: current_user.email)
          current_user.update!(stripe_customer_id: customer.id)
          Rails.logger.info "Stripe customer created successfully: #{customer.id}"
        rescue Stripe::InvalidRequestError => e
          flash[:alert] = "Failed to create Stripe customer: #{e.message}"
          Rails.logger.error "Stripe customer creation failed: #{e.message}"
          render :new and return
        rescue StandardError => e
          flash[:alert] = "Unexpected error occurred while creating Stripe customer."
          Rails.logger.error "Error: #{e.message}"
          render :new and return
        end
      else
        flash[:alert] = "Your email address is invalid or missing. Please update your profile."
        Rails.logger.warn "User email invalid or missing for customer creation."
        render :edit_profile and return
      end
    end
  
    # Proceed with booking creation
    if @booking.save
      UserMailer.booking_notification(current_user).deliver_now
      flash[:notice] = "Booking successfully created!"
  
      # Process payment if total price exists
      if @booking.total_price.present?
        amount_in_cents = (@booking.total_price * 100).to_i
        token = params[:stripeToken]
  
        # Check for missing Stripe token
        if token.blank?
          flash.now[:alert] = "Stripe token is missing. Please try again."
          render :new and return
        end
  
        begin
          charge = Stripe::Charge.create(
            source: token,
            amount: amount_in_cents,
            description: "Payment for Booking ID: #{@booking.id}",
            currency: 'usd'
          )
          Rails.logger.info "Stripe charge created: #{charge.inspect}"
  
          # Check if charge was successful
          if charge.id.present?
            @booking.update!(stripe_charge_id: charge.id)
            Transaction.create!(
              user: current_user,
              stripe_charge_id: charge.id,
              amount: amount_in_cents,
              currency: 'usd',
              status: charge.status
            )
            redirect_to @booking, notice: 'Booking was successfully created and payment processed.'
          else
            flash.now[:alert] = "Payment processing failed. Please try again."
            Rails.logger.error "Payment processing failed for Booking ID: #{@booking.id}"
            render :new
          end
        rescue Stripe::CardError => e
          flash[:error] = e.message
          Rails.logger.error "Stripe card error: #{e.message}"
          render :new
        rescue StandardError => e
          flash[:alert] = "Unexpected error occurred during payment processing."
          Rails.logger.error "Payment error: #{e.message}"
          render :new
        end
      else
        # If no payment is required, simply redirect to the booking
        redirect_to @booking, notice: 'Booking was successfully created!'
      end
    else
      # If booking save fails, render form with errors
      flash.now[:alert] = @booking.errors.full_messages.join(", ")
      Rails.logger.error "Booking creation failed: #{@booking.errors.full_messages.join(", ")}"
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
