class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer

  enum status: [:Preparing, :Ready, :"On The Way", :Picked]
end
