class User < ApplicationRecord
  has_secure_password
  has_one :business, dependent: :destroy
  # Order checkins with most recent first
  has_many :checkins, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, through: :checkins

  # Username must be unique and between 4 and 20 characters
  validates :username,
            presence: true,
            uniqueness: true,
            length: {
              minimum: 4,
              maximum: 20,
            }

  # Email must be valid, unique and not more than 64 characters
  validates :email,
            presence: true,
            uniqueness: true,
            length: {
              maximum: 64,
            },
            format: {
              with: /\A[^@]+@[^@]+\.[^@]+\z/,
              message: 'must be a valid email address',
            }

  # Password must be at least 8 characters and contain uppercase letter, lowercase letter and number
  validates :password,
            length: {
              minimum: 8,
            },
            format: {
              with: /\A.*(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*\z/,
              message:
                'must contain at least one uppercase letter, one lowercase letter and one number',
            },
            if: -> { password.present? } # Runs validation only on the password itself (not the generated password_digest)
  validates :password_digest, presence: true
end
