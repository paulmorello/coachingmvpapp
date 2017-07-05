class Video < ApplicationRecord
  belongs_to :users
  has_one :game
  has_one :practice_session
end
