ActiveAdmin.register Booking do
  permit_params :car_id, :start_date, :end_date, :status, :total_price # Aur jo bhi attributes hain

  index do
    selectable_column
    id_column
    column :user
    column :status
    actions do |booking|
      item "Cancel", cancel_admin_booking_path(booking), method: :put if booking.status != 'cancelled'
      item "View", admin_booking_path(booking)
    end
  end

  member_action :cancel, method: :put do
    booking = Booking.find(params[:id])
    if booking.update(status: 'cancelled') # Error handling ke liye
      redirect_to admin_bookings_path, notice: "Booking has been cancelled."
    else
      redirect_to admin_bookings_path, alert: "Failed to cancel the booking."
    end
  end
end
