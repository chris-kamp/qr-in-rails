class User < ApplicationRecord
  has_secure_password
  has_one :business, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :checkins, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
