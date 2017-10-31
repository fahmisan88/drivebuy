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

  def update_location
    customer = current_user.customer
    order = customer.orders.where(status: 4).last
    customer.update(location_params)
    if order
      distance = Geocoder::Calculations.distance_between([customer.lat,customer.long], [order.restaurant.latitude,order.restaurant.longitude])
      if distance <= 0.05
        order.update(status: 5)
        render json: {arrive: true}, status: :ok
      else
        render json: {arrive: false}, status: :ok
      end
    else
      render json: {error: "You either arrived or have no pending order..", is_success: false}
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
