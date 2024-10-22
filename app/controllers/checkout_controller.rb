class CheckoutController < ApplicationController
  def success
    @booking = Booking.find(params[:booking_id])
    UserMailer.booking_notification(current_user, @booking).deliver_now
    flash[:notice] = 'Payment successful! Booking confirmed and email sent.'
    

   Transaction.create!(
    user_id: current_user.id,
    booking_id: @booking.id,
    stripe_charge_id: session.id, 
    amount: @booking.total_price, 
    currency: 'inr',
    status: @booking.status 
  )

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
