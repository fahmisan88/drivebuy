class Api::V1::RestaurantsController < Api::V1::BaseController

  def index
    if params[:latitude].present? && params[:longitude].present?
      restaurants = Restaurant.near([params[:latitude],params[:longitude]],30)
      render json: restaurants, status: :ok
    else
      restaurants = Restaurant.all
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

end
