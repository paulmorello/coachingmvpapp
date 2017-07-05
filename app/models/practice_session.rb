class PracticeSession < ApplicationRecord
  belongs_to :users
  has_one :video
end
