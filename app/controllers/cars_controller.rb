class CarsController < ApplicationController
  before_action :authenticate_user!
  def index
    @cars = Car.all
    if params[:query].present?
      @cars = Car.where("name ILIKE ?", "%#{params[:query]}%")
    end
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to @car
    else
      render :new
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
    debugger
    params.require(:car).permit(:title, :description, :price, :available, :photo)
  end
end
