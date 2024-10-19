class CheckoutController < ApplicationController
    def success
        @booking = Booking.find(params[:booking_id])
        @booking.update(status: "confirmed") # Payment successful, update booking status
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
