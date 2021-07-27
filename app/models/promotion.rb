class Promotion < ApplicationRecord
  belongs_to :business

  # Retrieve only those promotions which are active (have an end date in the future)
  scope :active, -> { where('end_date >= ?', DateTime.now) }
end
