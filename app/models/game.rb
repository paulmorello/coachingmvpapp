class Game < ApplicationRecord
  belongs_to :users, optional: true
  has_one :video
  has_one :stat, dependent: :destroy

  before_validation :normalize_game_info

  # validations
  validates :title, :date, :game_url, :team_name, :opponent_name, :team_score, :opponent_score, :player_number, presence: true

  validates :team_name, :opponent_name, length: {
    in: 5..80
  }

  validates :team_score, :opponent_score, :player_number, numericality: {
    greater_than: -1, less_than: 100
  }

  private
    # make Game info consistent
    def normalize_game_info
      self.title = title.downcase.titleize
      self.team_name = team_name.downcase.titleize
      self.opponent_name = opponent_name.downcase.titleize
    end
end
