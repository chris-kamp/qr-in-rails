class Category < ApplicationRecord
  has_many :businesses, dependent: :destroy

  # Category name must be unique
  validates :name, presence: true, uniqueness: true
end
