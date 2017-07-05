class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.text :title
      t.date :game_date
      t.text :video_url
      t.integer :practice_session_id
      t.integer :game_id

      t.timestamps
    end
  end
end
