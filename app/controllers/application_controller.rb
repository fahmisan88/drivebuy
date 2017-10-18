class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # check if user is an admin
  def check_if_admin
    if !current_user.admin?
      flash[:alert] = 'Sorry, only admins allowed!'
      redirect_to root_path
    end
  end

  protected

  def after_sign_in_path_for(resource_or_scope)
    if resource.admin
      root_path
    else
      meals_path
    end
  end

end
