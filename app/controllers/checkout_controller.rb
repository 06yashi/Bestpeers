class CheckoutController < ApplicationController
  def success
    @booking = Booking.find(params[:booking_id])
    
    # Ensure payment_intent is stored in the session when creating the payment
    payment_intent_id = session[:payment_intent] # Access payment_intent from session
  byebug
    if payment_intent_id
      charge = Stripe::PaymentIntent.retrieve(payment_intent_id) # Retrieve charge details
      byebug
      if charge && charge.charges.data.any?
        byebug
        @booking.update(
          status: "confirmed",
          stripe_charge_id: charge.charges.data.first.id,
          payment_intent_id: payment_intent_id
        )
      end
    
    else
      @booking.update(status: "confirmed")
      # Send the email notification
    UserMailer.booking_notification(current_user, @booking).deliver_now
    flash[:notice] = 'Payment successful! Booking confirmed and email sent.'
      # Fallback if payment intent is not available
    end

    flash[:notice] = "Payment successful! Your booking is confirmed."
    redirect_to booking_path(@booking) # Redirect to booking show page
  end

  def cancel
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: "cancelled") # Payment cancelled, update booking status
    flash[:alert] = "Payment was cancelled."
    redirect_to root_path # Redirect to home page
  end
end
