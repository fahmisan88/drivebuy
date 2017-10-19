class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :meals

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
