class Stat < ApplicationRecord
  belongs_to :users
  has_one :game

  #validations
  validates :game_started, :minutes, :fgm, :fga, :fgp, :threepm, :threepa, :threepp, :ftm, :fta, :ftp, :offensive_reb, :defensive_reb, :total_reb, :assists, :steals, :block, :turnovers, :pfs, :points, :plus_minus, :min_on, :min_off, :plus_minus_on, :plus_minus_off, :lineup_plus_minus, numericality: {
    greater_than: -100, less_than: 100
  }

end
