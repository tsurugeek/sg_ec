class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_one :shipping_address, as: :shippable, dependent: :destroy
  accepts_nested_attributes_for :shipping_address

  validates :email, length: { maximum: 255 }

  after_create do |user|
    user.create_shipping_address
  end
end
