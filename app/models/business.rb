class Business < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :checkins, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, through: :checkins
  has_many :promotions, dependent: :destroy
  has_one :address, required: true, dependent: :destroy

  validates_associated :address
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  scope :filter_by_category, ->(category_id) { where category_id: category_id }

  def active_promotions
    self.promotions.active
  end

  def weekly_checkin_count
    self.checkins.where('created_at >= ?', DateTime.now - 7).count
  end
end
