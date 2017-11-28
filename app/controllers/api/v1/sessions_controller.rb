class Api::V1::SessionsController < Api::V1::BaseController
  before_action :authenticate_with_token!, only: :logout

  def login
    user = User.find_by(email: user_params[:email])
    if user && user.valid_password?(user_params[:password])
      user.generate_authentication_token
      user.save
      render json: user, status: :ok
    else
      render json: {error: "Email or Password is wrong", is_success: false}
    end
  end

  def logout
    user = User.find_by(access_token: params[:access_token])
    user.generate_authentication_token
    user.save
    render json: {is_success: true}, status: :ok
  end

  def check
    user = User.find_by(access_token: params[:access_token])
    if user
      render json: {is_success: true}, status: :ok
    else
      render json: {is_success: false}
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
