class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.text :title
      t.date :date
      t.text :game_url
      t.text :team_name
      t.text :opponent_name
      t.integer :user_id
      t.integer :team_score
      t.integer :opponent_score
      t.integer :stat_id
      t.integer :game_number
      t.integer :player_number
      t.boolean :needs_review

      t.timestamps
    end
  end
end
