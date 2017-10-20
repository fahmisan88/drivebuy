class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  has_many :order_details

  enum status: [:Awaiting, :Preparing, :Decline, :Ready, :"On The Way", :Arrived, :Picked]
end
