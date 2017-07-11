class Video < ApplicationRecord
  belongs_to :users, optional: true
  has_one :game
  has_one :practice_session
end
