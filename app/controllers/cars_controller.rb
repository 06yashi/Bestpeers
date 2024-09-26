class CarsController < ApplicationController
 
  def index
    @cars = Car.all

    if params[:model].present?
      @cars = @cars.where('model ILIKE ?', "%#{params[:model]}%")
    end

    if params[:fuel_type].present?
      @cars = @cars.where(fuel_type: params[:fuel_type])
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

  private

  def car_params
    params.require(:car).permit(:title, :description, :price, :available)
  end
end
