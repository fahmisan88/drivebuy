class Api::V1::CustomersController < Api::V1::BaseController
  before_action :authenticate_with_token!

  def update
    customer = current_user.customer
    if customer.update(customer_params)
      render json: customer, status: :ok
    else
      render json: {error: "Something went wrong...", is_success: false}
    end
  end

  # POST: customer update locations while on the way to pickup order
  def update_location
    customer = current_user.customer
    order = customer.orders.where(status: 5).last
    customer.update(location_params)
    # Check if customer location is within 50 meters from pickup location then change status from on the way to arrive.
    # Function to notify restaurant will built later
    if order
      distance = Geocoder::Calculations.distance_between([customer.lat,customer.long], [order.restaurant.latitude,order.restaurant.longitude])
      if distance <= 0.05
        order.update(status: 6)
        render json: {arrive: true}, status: :ok
      else
        render json: {arrive: false}, status: :ok
      end
    else
      render json: {error: "You either arrived or have no pending order..", is_success: false}
    end
  end

  def fetch_info
    customer = current_user.customer
    if customer
      render json: customer, status: :ok
    else
      render json: {error: "No user exist", is_success: false}
    end
  end

  private

  def customer_params
    params.permit(:name, :phone, :plate_num, :car_desc)
  end

  def location_params
    params.permit(:lat, :long)
  end
end
