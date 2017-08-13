class User < ApplicationRecord
  has_secure_password

  has_many :games, dependent: :destroy
  has_many :practice_sessions, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :stats, dependent: :destroy

  # carrierwave uploader for avatars
  mount_uploader :new_avatar, ProfileUploader

  # Validation constraints
  validates :email, :username, presence: true
  validates :email, uniqueness: true

  validates :username, uniqueness: true, length: {
    in: 4..40,
    },
    format: {
      without: /[^a-z0-9]/i,
      message: "no special characters or spacing"
    },
    exclusion: {
      :in => %w(login signup settings add search browse archive),
      message: "has already been taken"
    }
  validates :email, length: {
    in: 10..100,
    },
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

end
