class Api::V1::OrdersController < Api::V1::BaseController
  before_action :authenticate_with_token!

#----------------------Customer Actions----------------------#
  # POST: customer place order. Params containing access_token, restaurant_id, order_details {meal_id: ???, quantity: ???}, plate_num, car_desc
  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    customer = current_user.customer
    order_details = JSON.parse(params[:order_details].to_json)
    order_total = 0

    if customer.orders.last && customer.orders.last.status != "Picked" && customer.orders.last.status != "Declined" && customer.orders.last.status != "Cancelled"
      render json: {error: "You have to complete your current order first", is_success: false}
    elsif params[:plate_num].nil? || params[:plate_num].blank?
      render json: {error: "Your vehicle plate number is required", is_success: false}
    elsif params[:car_desc].nil? || params[:car_desc].blank?
      render json: {error: "Your vehicle description is required", is_success: false}
    else
      # Get total for all orders
      for meal in order_details
        order_total += Meal.find_by(id: meal["meal_id"]).price * meal["quantity"]
      end

      # Create an order
      if order_details.length > 0
        order = Order.create(
                  customer_id: customer.id,
                  restaurant_id: restaurant.id,
                  total: order_total
                  )
      end

      # Create order details
      for meal in order_details
        OrderDetail.create(
          order_id: order.id,
          meal_id: meal["meal_id"],
          quantity: meal["quantity"],
          sub_total: Meal.find_by(id: meal["meal_id"]).price * meal["quantity"]
          )
      end

      #update customer details
      customer.update(customer_params)

      render json: {is_success: true}, status: :ok
    end
  end

  # POST: customer notify they on the way to pickup order
  def on_the_way
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 5)
    order.customer.update(lat: params[:latitude], long: params[:longitude])
    render json: {is_success: true}, status: :ok
  end

  # POST: customer manually notify when they arrive at pickup location. (for those phone without GPS)
  def arrive
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 6)
    render json: {is_success: true}, status: :ok
  end

  # POST: customer cancel their order
  def cancel
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 9)
    render json: {is_success: true}, status: :ok
  end

  # POST: customer notify they have pick up their order
  def pick
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 8)
    render json: {is_success: true}, status: :ok
  end

  # POST for customer current order
  def current_order
    order = current_user.customer.orders.last
    render json: order.as_json(include: [:restaurant, {order_details: {include: :meal}}]), status: :ok
  end

  # Listen for order status to be ready. Polling every 3 seconds
  def is_ready
    order = current_user.customer.orders.find(params[:id])
    if order.status == "Ready"
      render json: {is_ready: true}
    else
      render json: {is_ready: false}
    end
  end


#----------------------Restaurant Actions----------------------#

  # POST: restaurant accept the requested order
  def approve
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 1)
    render json: {is_success: true}, status: :ok
  end

  # POST: restaurant decline the requested order
  def decline
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 2)
    render json: {is_success: true}, status: :ok
  end

  # POST: restaurant notify that order is ready for pick up
  def ready
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 4)
    render json: {is_success: true}, status: :ok
  end

  # POST: restaurant notify they have deliver order to customer car
  def deliver
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 7)
    render json: {is_success: true}, status: :ok
  end

  # POST: Restaurant current order page Need to listen for changes in status, Polling every 3 seconds
  def list_customer_orders
    orders = current_user.restaurant.orders.where.not("status = ? OR status = ? OR status = ? OR status = ?", 2, 7, 8, 9)

    if orders.where(status: 6).length > 0 || orders.where(status: 0).length > 0
      render json: {orders: orders.as_json(include: :customer), notify: true}, status: :ok
    else
      render json: {orders: orders.as_json(include: :customer), notify: false}, status: :ok
    end
  end

  # POST: Restaurant view one customer order
  def customer_order
    order = current_user.restaurant.orders.find(params[:id])
    render json: order.as_json(include: [:customer, {order_details: {include: :meal}}]), status: :ok
  end

  private
  def customer_params
    params.permit(:plate_num, :car_desc, :lat, :long)
  end

end
