class Api::V1::OrdersController < Api::V1::BaseController
  before_action :authenticate_with_token!

  def create
    # Get POST request containing access_token, restaurant_id, order_details {meal_id: ???, quantity: ???}
    restaurant = Restaurant.find(params[:restaurant_id])
    customer = Customer.find_by(user_id: current_user.id)
    order_details = JSON.parse(params[:order_details].to_json)
    order_total = 0

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

    render json: {is_success: true}, status: :ok

  end

end
