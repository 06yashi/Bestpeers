class AddPaymentIntentIdToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :payment_intent_id, :string
  end
end
