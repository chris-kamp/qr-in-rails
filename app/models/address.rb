class Address < ApplicationRecord
  belongs_to :state
  belongs_to :postcode
  belongs_to :suburb
  belongs_to :business

  validates_associated :state
  validates_associated :postcode
  validates_associated :suburb
  validates :street, presence: true
end
