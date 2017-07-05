class Game < ApplicationRecord
  belongs_to :users
  has_one :video
  has_one :stat
end
