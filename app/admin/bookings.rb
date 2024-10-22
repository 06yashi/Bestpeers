ActiveAdmin.register Booking do
  # Permit the payment_intent_id parameter
  permit_params :car_id, :start_date, :end_date, :status, :total_price

  # Filters
  filter :car_id
  filter :user
  filter :status
  filter :total_price
  filter :payment_intent_id  # Add this line

  # Display options
  index do
    selectable_column  # This should work as long as you're inside the index block
    id_column
    column :email
    column :created_at
    actions do |booking|  # Move actions block inside index
      item "Cancel", cancel_admin_booking_path(booking), method: :put if booking.status != 'cancelled'
      item "View", admin_booking_path(booking)
    end
  end

  member_action :cancel, method: :put do
    booking = Booking.find(params[:id])
    if booking.update(status: 'cancelled')  # Error handling ke liye
      redirect_to admin_bookings_path, notice: "Booking has been cancelled."
    else
      redirect_to admin_bookings_path, alert: "Failed to cancel the booking."
    end
  end
end
