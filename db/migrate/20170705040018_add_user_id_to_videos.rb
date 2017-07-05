class AddUserIdToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :user_id, :integer
  end
end
