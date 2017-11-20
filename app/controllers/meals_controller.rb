class MealsController < ApplicationController
  before_action :set_meal, except: [:create, :index]

  def index
    @foods = current_user.restaurant.meals.where(meal_type: 0)
    @drinks = current_user.restaurant.meals.where(meal_type: 1)
    @meal = Meal.new
  end

  def create
    @meal = current_user.restaurant.meals.build(meal_params)
    if @meal.save
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def show

  end

  def update
    if @meal.update(meal_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_to meals_path
  end

  def enable
    @meal.update(available: true)
    flash[:notice] = "Enable..."
    redirect_back(fallback_location: request.referer)
  end

  def disable
    @meal.update(available: false)
    flash[:notice] = "Disable..."
    redirect_back(fallback_location: request.referer)
  end

  private

  def meal_params
    params.require(:meal).permit(:name, :desc, :price, :meal_type, :available, :code)
  end

  def set_meal
    @meal = Meal.find(params[:id])
  end

end
