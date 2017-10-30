class Api::V1::RegistrationsController < Api::V1::BaseController

  def create
    user = User.new(user_params)
    if !user_params["customer_attributes"]["name"].blank? && !user_params["customer_attributes"]["phone"].blank?
      if user.save
        render json: user, status: :ok
      else
        render json: {error: user.errors, is_success: false}
      end
    else
      render json: {error: "Name or phone can't be blank", is_success: false}
    end
  end

  private

  def user_params
    params.permit(:email, :password, [customer_attributes: [:name, :phone]])
  end
end
