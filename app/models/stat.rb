class Stat < ApplicationRecord
  belongs_to :users
  has_one :game

end
