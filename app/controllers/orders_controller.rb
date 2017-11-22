class OrdersController < ApplicationController

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
