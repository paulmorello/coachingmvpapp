class PracticeSession < ApplicationRecord
  belongs_to :users, optional: true
  has_one :video, dependent: :destroy

  # validations
  validates :title, :date, :practice_session_url, presence: true

  private
    # make Game info consistent
    def normalize_game_info
      self.title = title.downcase.titleize
    end
end
