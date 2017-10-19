class Api::V1::CustomersController < Api::V1::BaseController
  before_action :authenticate_with_token!

  def update
    customer = Customer.find_by(user_id: current_user.id)
    if customer.update(customer_params)
      render json: customer, status: :ok
    else
      render json: {error: "Something went wrong...", is_success: false}
    end
  end

  private

  def customer_params
    params.permit(:name, :phone, :plate_num, :car_desc)
  end
end
