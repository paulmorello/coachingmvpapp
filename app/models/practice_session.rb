class PracticeSession < ApplicationRecord
  belongs_to :users, optional: true
  has_one :video

  # validations
  validates :title, presence: true
end
