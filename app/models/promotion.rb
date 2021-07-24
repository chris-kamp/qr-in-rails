class Promotion < ApplicationRecord
  belongs_to :business

  scope :active, -> { where('end_date >= ?', DateTime.now) }
end
