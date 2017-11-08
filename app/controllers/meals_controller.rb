class MealsController < ApplicationController
  before_action :set_meal, except: [:new, :create, :index]

  def index
    @meals = current_user.restaurant.meals
  end

  def new
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

  def edit

  end

  def update
    if @meal.update(meal_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @meal.destroy
    flash[:notice] = "Meal Removed..."
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
    params.require(:meal).permit(:name, :desc, :price, :meal_type, :available)
  end

  def set_meal
    @meal = Meal.find(params[:id])
  end

end
