class RestaurantsController < ApplicationController
  before_action :set_restaurant

  def edit

  end

  def update
    if @restaurant.update(restaurant_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :prepare_time, :phone)
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end

end
