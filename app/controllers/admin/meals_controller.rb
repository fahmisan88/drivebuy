class Admin::MealsController < ApplicationController
  before_action :check_if_admin
  before_action :set_meal, except: [:create]

  def show

  end

  def create
    @meal = Meal.new(meal_params)
    if @meal.save
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def update
    @restaurant = Restaurant.find_by(id: @meal.restaurant_id)
    if @meal.update(meal_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_to menu_admin_restaurant_path(@restaurant)
  end

  def destroy

  end

  private

  def meal_params
    params.require(:meal).permit(:name, :desc, :price, :restaurant_id, :meal_type, :available)
  end

  def set_meal
    @meal = Meal.find(params[:id])
  end

end
