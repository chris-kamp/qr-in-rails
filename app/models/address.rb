class Address < ApplicationRecord
  belongs_to :state
  belongs_to :postcode
  belongs_to :suburb
  belongs_to :business
end
