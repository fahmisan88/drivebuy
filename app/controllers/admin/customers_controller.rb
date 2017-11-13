class Admin::CustomersController < ApplicationController
  before_action :check_if_admin
  before_action :set_customer, except: :index

  def index
    @customers = Customer.all.order("created_at DESC")
    if params[:search]
      @customers = Customer.search(params[:search]).order("created_at DESC")
    end
  end

  def show

  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def orders
    @orders = @customer.orders
  end

  def destroy

  end

  private

  def customer_params
    params.require(:customer).permit(:name, :plate_num, :phone, :car_desc, :status)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

end
