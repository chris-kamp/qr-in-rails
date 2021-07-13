class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :checkins, dependent: :destroy
  has_one :address, required: true, dependent: :destroy
end
