class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders

  def self.search(search)
    where('name ILIKE :search', search: "%#{search}%")
  end

  enum status: [:Active, :Inactive]

end
