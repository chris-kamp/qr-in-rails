class Postcode < ApplicationRecord
  has_many :addresses

  validates :code, presence: true
end
