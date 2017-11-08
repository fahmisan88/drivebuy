class Admin::RestaurantsController < ApplicationController
  before_action :check_if_admin
  before_action :set_restaurant, except: :index

  def index
    @restaurants = Restaurant.all.order("created_at DESC")
    if params[:search]
      @restaurants = Restaurant.search(params[:search]).order("created_at DESC")
    end
  end

  def show

  end

  def update
    if @restaurant.update(restaurant_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def menu
    @foods = @restaurant.meals.where(meal_type: 0)
    @drinks = @restaurant.meals.where(meal_type: 1)
    @meal = Meal.new
    if params[:search]
      @foods = @restaurant.meals.where(meal_type: 0).search(params[:search]).order("created_at DESC")
      @drinks = @restaurant.meals.where(meal_type: 1).search(params[:search]).order("created_at DESC")
    end
  end

  def destroy

  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :latitude, :longitude, :prepare_time, :status)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

end
