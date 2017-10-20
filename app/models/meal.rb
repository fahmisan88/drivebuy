class Meal < ApplicationRecord
  belongs_to :restaurant
  has_many :order_details
end
