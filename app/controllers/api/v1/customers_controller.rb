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
    customer.update(location_params)
    render json: {is_success: true}, status: :ok
  end

  private

  def customer_params
    params.permit(:name, :phone, :plate_num, :car_desc)
  end

  def location_params
    params.permit(:lat, :long)
  end
end
