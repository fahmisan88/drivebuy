class RegistrationsController < Devise::RegistrationsController

  # GET /resource/sign_up
  def new
    build_resource({})
    self.resource.restaurant = Restaurant.new
    respond_with self.resource
  end

  # POST /resource
  def create
    super
  end

  private

  def sign_up_params
    allow = [:email, :password, :password_confirmation, [restaurant_attributes: [:name, :address, :phone, :prepare_time]]]
    params.require(resource_name).permit(allow)
  end

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
end
