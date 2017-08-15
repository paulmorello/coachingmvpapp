class User < ApplicationRecord
  has_secure_password

  has_many :games, dependent: :destroy
  has_many :practice_sessions, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :stats, dependent: :destroy

  # carrierwave uploader for avatars
  mount_uploader :new_avatar, ProfileUploader

  # Validation methods
  before_create { generate_token(:auth_token) }
  before_save :email_to_lower_case

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

  # User functions
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private

    def email_to_lower_case
      self.email = email.downcase
    end

end
