class Api::V1::OrdersController < Api::V1::BaseController
  before_action :authenticate_with_token!

#----------------------Customer Actions----------------------#
  # POST request to add order containing access_token, restaurant_id, order_details {meal_id: ???, quantity: ???}, plate_num, car_desc
  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    customer = current_user.customer
    order_details = JSON.parse(params[:order_details].to_json)
    order_total = 0

    if customer.orders.last.status != "Picked"
      render json: {error: "You have to pickup your last order first", is_success: false}
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
                  total: order_total,
                  status: 0
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

  def on_the_way
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 4)
    order.customer.update(lat: params[:latitude], long: params[:longitude])
    render json: {is_success: true}, status: :ok
  end

  def arrive
    order = current_user.customer.orders.find(params[:id])
    order.update(status: 5)
    render json: {is_success: true}, status: :ok
  end


#----------------------Restaurant Actions----------------------#
  def approve
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 1)
    render json: {is_success: true}, status: :ok
  end

  def decline
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 2)
    render json: {is_success: true}, status: :ok
  end

  def ready
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 3)
    render json: {is_success: true}, status: :ok
  end

  def deliver
    order = current_user.restaurant.orders.find(params[:id])
    order.update(status: 6)
    render json: {is_success: true}, status: :ok
  end

  # POST every 3 seconds to get and update orders status
  def list_customer_orders
    orders = current_user.restaurant.orders.where.not("status = ? OR status = ?", 2, 6)

    orders.where(status: 4).each do |order|
      if order.customer.lat? && order.customer.long?
        distance = Geocoder::Calculations.distance_between([order.customer.lat,order.customer.long], [order.restaurant.latitude,order.restaurant.longitude])
        if distance <= 0.05
          order.update(status: 5)
        end
      end
    end

    if orders.where(status: 5).length > 0 || orders.where(status: 0).length > 0
      render json: {orders: orders.as_json(include: :customer), notify: true}, status: :ok
    else
      render json: {orders: orders.as_json(include: :customer), notify: false}, status: :ok
    end
  end

  # POST for one customer order
  def customer_order
    order = current_user.restaurant.orders.find(params[:id])
    render json: order.as_json(include: [:customer, {order_details: {include: :meal}}]), status: :ok
  end

  private
  def customer_params
    params.permit(:plate_num, :car_desc, :lat, :long)
  end

end