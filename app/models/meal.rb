class Meal < ApplicationRecord
  belongs_to :restaurant
  has_many :order_details

  def self.search(search)
    where('name ILIKE :search', search: "%#{search}%")
  end

  enum meal_type: [:Food, :Drink]
end
