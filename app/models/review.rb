class Review < ApplicationRecord
  belongs_to :checkin
  validates :rating, presence: true
end
