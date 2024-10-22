class RemovePaymentIntentIdFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :payment_intent_id, :string
  end
end
