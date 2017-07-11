class Game < ApplicationRecord
  belongs_to :users, optional: true
  has_one :video
  has_one :stat
end
