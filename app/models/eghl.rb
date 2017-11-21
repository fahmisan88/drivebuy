class Eghl
  def initialize merchant_id, merchant_password, order
    # @booking = Booking.find_by(id: params[:id])
    @merchant_id          = merchant_id
    @merchant_password    = merchant_password
    @request_parameters   = {
      'TransactionType' => 'SALE',
      'PymtMethod' => 'CC',
      'ServiceID' => @merchant_id,
      'PaymentID' => ["DRIVE-2507-", order.payment.id].join(''),
      'OrderNumber' => ["R#{order.restaurant_id}-", order.id].join(''),
      'PaymentDesc' => order.restaurant.name,
      'MerchantReturnURL' => '',
      'MerchantCallBackURL' => '',
      'Amount' => sprintf("%.2f", order.total),
      'CurrencyCode' => 'MYR',
      'HashValue' => '',
      'CustIp' => '',
      'CustName' => order.customer.name,
      'CustEmail' => order.customer.user.email,
      'CustPhone' => order.customer.phone,
    }
    @response_parameters  = Hash.new
  end

  def write_request_parameter key, value
    @request_parameters[key] = value
  end

  # params for post method
  def request_parameters
    @request_parameters
  end

  # params for get method
  def response_parameters= params
    @response_parameters = params
  end

  # to convert certain params to hash value for security purpose before post
  def generate_request_signature
    string = []
    string << @merchant_password
    string << @request_parameters['ServiceID']
    string << @request_parameters['PaymentID']
    string << @request_parameters['MerchantReturnURL']
    string << @request_parameters['MerchantApprovalURL'] if @request_parameters.has_key? 'MerchantApprovalURL'
    string << @request_parameters['MerchantUnApprovalURL'] if @request_parameters.has_key? 'MerchantUnApprovalURL'
    string << @request_parameters['MerchantCallBackURL'] if @request_parameters.has_key? 'MerchantCallBackURL'
    string << @request_parameters['Amount']
    string << @request_parameters['CurrencyCode']
    string << @request_parameters['CustIp']
    string << @request_parameters['PageTimeout'] if @request_parameters.has_key? 'PageTimeout'
    string << @request_parameters['CardNo'] if @request_parameters.has_key? 'CardNo'
    string << @request_parameters['Token'] if @request_parameters.has_key? 'Token'
    @request_parameters['HashValue'] = Digest::SHA256.hexdigest(string.join(''))
    @hash_value = @request_parameters['HashValue'] = Digest::SHA256.hexdigest(string.join(''))
  end

  # to convert certain params received from eghl to check against our hashvalue to avoid tampered code
  def generate_response_signature
    string = []
    string << @merchant_password
    string << @response_parameters['TxnID']
    string << @response_parameters['ServiceID']
    string << @response_parameters['PaymentID']
    string << @response_parameters['TxnStatus']
    string << @response_parameters['Amount']
    string << @response_parameters['CurrencyCode']
    string << @response_parameters['AuthCode']
    Digest::SHA256.hexdigest(string.join(''))
  end

  def status
    case true
    when @response_parameters['HashValue'] != generate_response_signature
      "invalid"
    when @response_parameters['TxnStatus'] == "0"
      "success"
    when @response_parameters['TxnStatus'] == "1" && @response_parameters['TxnMessage'].strip == "Buyer cancelled"
      "cancelled"
    when @response_parameters['TxnStatus'] == "1"
      "failed"
    end
  end
end
