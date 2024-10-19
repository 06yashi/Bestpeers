class CheckoutController < ApplicationController
  def success
    session_id = params[:session_id]
    
    begin
      # Retrieve the checkout session
      session = Stripe::Checkout::Session.retrieve(session_id)
      
      # Get the PaymentIntent ID
      payment_intent_id = session.payment_intent
      
      # Manually capture the payment
      payment_intent = Stripe::PaymentIntent.capture(payment_intent_id)
      
      # Assuming you have a way to find the booking by session_id
      booking = Booking.find(params[:booking_id])
  
      if payment_intent && booking
        booking.update(stripe_charge_id: payment_intent.id, status: 'confirmed')
        
        flash[:notice] = "Payment successful and captured! Booking confirmed."
        redirect_to bookings_path
      else
        flash[:alert] = "Booking not found or session is invalid."
        redirect_to root_path
      end
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Stripe error while capturing payment: #{e.message}"
      flash[:alert] = "There was an error processing your payment."
      redirect_to root_path
    end
  end
  
  def cancel
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: "cancelled") # Payment cancelled, update booking status
    flash[:alert] = "Payment was cancelled."
    redirect_to root_path # Redirect to home page
  end
end
