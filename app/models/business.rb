class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :checkins, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, through: :checkins
  has_one :address, required: true, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  scope :filter_by_category, ->(category_id) { where category_id: category_id }
end
