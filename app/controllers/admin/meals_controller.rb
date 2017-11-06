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

  end

  def destroy

  end

  private

  def meal_params
    params.require(:meal).permit(:name, :desc, :price, :restaurant_id)
  end

  def set_meal
    @meal = Meal.find(params[:id])
  end

end
