class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  has_many :order_details
  has_one :payment

  enum status: [:Awaiting, :Approved, :Declined, :Confirmed, :Ready, :"On The Way", :Arrived, :Delivered, :Picked, :Cancelled]

  scope :current_week_revenue, -> (user) {
    joins(:restaurant)
    .where("orders.updated_at >= ? AND orders.status = ?", 1.week.ago, 7)
    .order(updated_at: :asc)
  }

  def self.search(search)
    where('order_id ILIKE :search', search: "%#{search}%")
  end

end
