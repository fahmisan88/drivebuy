class Api::V1::RestaurantsController < Api::V1::BaseController
  before_action :authenticate_with_token!, except: [:index, :show]

  #----------------------Customer Actions----------------------#
  def index
    if params[:latitude].present? && params[:longitude].present?
      restaurants = Restaurant.where(open: true).near([params[:latitude],params[:longitude]],30)
      render json: restaurants, status: :ok
    else
      restaurants = Restaurant.where(open: true)
      render json: restaurants, status: :ok
    end
  end

  def show
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      restaurant_meals = restaurant.meals.where(available: true)
      render json: {meals: restaurant_meals, is_success: true}, status: :ok
    else
      render json: {error: "Restaurant not found", is_success: false}
    end
  end

  #----------------------Restaurant Actions----------------------#

  # restaurant to visible in customer app
  def open
    restaurant = current_user.restaurant
    restaurant.update(open: true)
    render json: {open: true}, status: :ok
  end

  # restaurant turn off visibility in customer app
  def close
    restaurant = current_user.restaurant
    restaurant.update(open: false)
    render json: {open: false}, status: :ok
  end

  # restaurant views all meals they offered
  def menu
    foods = current_user.restaurant.meals.where(meal_type: 0)
    drinks = current_user.restaurant.meals.where(meal_type: 1)
    render json: {foods: foods, drinks: drinks, is_success: true}, status: :ok
  end

end
