class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  has_many :order_details

  enum status: [:Awaiting, :Approved, :Declined, :Confirmed, :Ready, :"On The Way", :Arrived, :Delivered, :Picked, :Cancelled]
end
