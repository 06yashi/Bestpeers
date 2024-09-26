class ChangeUserIdToBeOptionalInCars < ActiveRecord::Migration[7.1]
  def change
    change_column_null :cars, :user_id, true
  end
end
