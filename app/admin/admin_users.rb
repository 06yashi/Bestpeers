ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  # Filter by booking status or any specific field in bookings
  filter :bookings_status, as: :select, collection: Booking.pluck(:status).uniq, label: 'Booking Status'
  # Add other filters as needed

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    column "Bookings Count" do |user|
      user.bookings.count
    end
    actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
