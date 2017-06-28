class CreateStats < ActiveRecord::Migration[5.1]
  def change
    create_table :stats do |t|
      t.integer :game_id
      t.integer :user_id
      t.boolean :game_started
      t.integer :minutes
      t.integer :fgm
      t.integer :fga
      t.integer :fgp
      t.integer :threepm
      t.integer :threepa
      t.integer :threepp
      t.integer :ftm
      t.integer :fta
      t.integer :ftp
      t.integer :offensive_reb
      t.integer :defensive_reb
      t.integer :total_reb
      t.integer :assists
      t.integer :steals
      t.integer :block
      t.integer :turnovers
      t.integer :pfs
      t.integer :points
      t.integer :plus_minus
      t.integer :min_on
      t.integer :min_off
      t.integer :plus_minus_on
      t.integer :plus_minus_off
      t.text :player_lineup_numbers
      t.integer :lineup_plus_minus
      t.text :game_notes
      t.text :player_tendencies

      t.timestamps
    end
  end
end
