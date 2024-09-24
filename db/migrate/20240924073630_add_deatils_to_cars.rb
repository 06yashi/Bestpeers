class AddDeatilsToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :price, :decimal
    add_column :cars, :fuel_type, :string
    add_column :cars, :seating_capacity, :integer
  end
end
