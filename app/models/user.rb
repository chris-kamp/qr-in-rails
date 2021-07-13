class User < ApplicationRecord
  has_secure_password
  has_one :business, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :checkins, dependent: :destroy
end
