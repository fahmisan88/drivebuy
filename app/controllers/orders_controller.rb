class OrdersController < ApplicationController
  # skip verify token use to solve the request origin does not match request base_url error
  skip_before_action :verify_authenticity_token

  def pay
    @order = Order.find_by(id: params[:id])
    Payment.create!(order_id: @order.id, customer_id: @order.customer_id, restaurant_id: @order.restaurant_id)
    @eghl =  Eghl.new "sit", "sit12345", @order
    # method to add params in request parameters
    @eghl.write_request_parameter('MerchantReturnURL', return_order_url(@order.id))
    @eghl.write_request_parameter('MerchantCallBackURL', callback_order_url(@order.id))
    @eghl.write_request_parameter('CustIp', request.remote_ip)
    # method to hash certain params in request parameters
    @eghl.generate_request_signature

    # not to include layout for pay.html.erb
    render layout: false
  end

  def return
    order = Order.find_by(id: params[:id])
    if order
      eghl = Eghl.new "sit", "sit12345", order
      eghl.response_parameters = params.except(:id)
      order.payment.update(status: params['TxnStatus'].to_i, txid: params['TxnID'], message: params['TxnMessage'], method: params['PymtMethod'], amount: params['Amount'].to_d)
      if eghl.status == 'success'
        order.update(status: 3, order_id: ["R#{order.restaurant_id}-", order.restaurant.payments.where(status: 0).count].join(''))
        render 'payment_success'
      else
        render 'payment_fail'
      end
    end
  end

  def callback
    order = Order.find_by(id: params[:id])
    if order
      eghl = Eghl.new "sit", "sit12345", order
      eghl.response_parameters = params.except(:id)
      order.payment.update(status: params['TxnStatus'].to_i, txid: params['TxnID'], message: params['TxnMessage'], method: params['PymtMethod'], amount: params['Amount'].to_d)
      if eghl.status == 'success'
        order.update(status: 3, order_id: ["R#{order.restaurant_id}-", order.restaurant.payments.where(status: 0).count].join(''))
      end
    end
    render text: 'OK'
  end

  def payment_success
    render layout: false
  end

  def payment_fail
    render layout: false
  end

end
