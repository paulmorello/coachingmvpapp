class Stat < ApplicationRecord
  belongs_to :users, optional: true
  has_one :game

  #validations
  validates :minutes, :fgm, :fga, :threepm, :threepa, :ftm, :fta, :offensive_reb, :defensive_reb, :total_reb, :assists, :steals, :block, :turnovers, :pfs, :points, numericality: {
    greater_than: -100, less_than: 100
  }

end
