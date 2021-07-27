class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :checkins, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, through: :checkins
  has_many :promotions, dependent: :destroy
  has_one :address, required: true, dependent: :destroy

  validates_associated :address
  # Validation of business attributes
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Filter Businesses where category_id matches given category or categories
  scope :filter_by_category, ->(category_id) { where category_id: category_id }

  # Promotions with the active scope
  def active_promotions
    return promotions.active
  end


  # Number of checkins created for this business in the last week
  def weekly_checkin_count
    return checkins.where('created_at >= ?', DateTime.now - 7).count
  end
end
