class Drill < ApplicationRecord

  # validations
  validates :title, :category, :drill_url, :description, presence: true

  validates :description, length: {
    in: 100..200
  }

  private
    # make Drill info consistent
    def normalize_game_info
      self.title = title.downcase.titleize
      self.category = category.downcase.titleize
    end
end
