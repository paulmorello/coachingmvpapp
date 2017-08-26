class AddVideoReviewsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :video_reviews, :integer
  end
end
