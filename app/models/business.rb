class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  # Order checkin associations with most recent first
  has_many :checkins, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, through: :checkins
  has_many :promotions, dependent: :destroy
  has_one :address, required: true, dependent: :destroy
  # Address association must be valid
  validates_associated :address

  # Business name must be unique
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Retrieve only those businesses whose category matches a given category id
  scope :filter_by_category, ->(category_id) { where category_id: category_id }

  # Retrieve active promotions associated with the business (using the "active" scope of the promotion model)
  def active_promotions
    return promotions.active
  end

  # Get the number of checkins created for a business in the past 7 days
  def weekly_checkin_count
    return checkins.where('created_at >= ?', DateTime.now - 7).count
  end
end
