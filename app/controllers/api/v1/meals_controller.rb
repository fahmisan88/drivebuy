class Api::V1::MealsController < Api::V1::BaseController
  before_action :authenticate_with_token!

  # restaurant to enable meal in the menu
  def enable
    meal = current_user.restaurant.meals.find(params[:id])
    meal.update(available: true)
    render json: {is_success: true}
  end

  # restaurant to disable meal in the menu
  def disable
    meal = current_user.restaurant.meals.find(params[:id])
    meal.update(available: false)
    render json: {is_success: true}
  end

end
