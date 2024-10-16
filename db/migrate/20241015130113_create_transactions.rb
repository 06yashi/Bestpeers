class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_charge_id
      t.integer :amount
      t.string :currency
      t.string :status

      t.timestamps
    end
  end
end
