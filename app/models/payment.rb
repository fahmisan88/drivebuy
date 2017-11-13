class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :restaurant
  belongs_to :customer

  enum status: [:Success, :Failed, :Pending]
end
