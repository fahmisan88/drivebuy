class Api::V1::RegistrationsController < Api::V1::BaseController

  def create
    user = User.new(user_params)
    if user.save
      user.create_customer!
      render json: user, status: :ok
    else
      render json: {error: user.errors, is_success: false}
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
