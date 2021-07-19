class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :checkins, dependent: :destroy
  has_many :reviews, through: :checkins
  has_one :address, required: true, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
