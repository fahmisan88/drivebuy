class User < ApplicationRecord
  before_create :generate_authentication_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :restaurant, dependent: :destroy
  has_one :customer, dependent: :destroy
  accepts_nested_attributes_for :restaurant

  def generate_authentication_token
   begin
     self.access_token = Devise.friendly_token
   end while self.class.exists?(access_token: access_token)
  end

end
