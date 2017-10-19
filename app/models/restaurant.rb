class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :meals
  has_many :orders

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
