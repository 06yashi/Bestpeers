
class CarsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # byebug
    if params[:query].present?
      # @cars = Car.where("name ILIKE ?", "%#{params[:query]}%")
      @cars = Car.find_by(name: params[:query].capitalize)
    else
      @cars = Car.all
    end
  end


  def search
    if params[:query].present?
      query = params[:query].strip.downcase 
      query_numeric = query.to_i 
      price_numeric = query.to_f 
  
      Rails.logger.debug "Search Query: #{query}"
  
     
      @cars = Car.where(
        "LOWER(name) LIKE ? OR LOWER(fuel_type) LIKE ? OR seating_capacity = ? OR price = ?", 
        "%#{query}%", "%#{query}%", query_numeric, price_numeric
      )
    else
      @cars = Car.all 
    end
  
    render :index 
  end
  
  

  private

  def car_params
    params.require(:car).permit(:title, :description, :price, :available, :photo)
  end
end
