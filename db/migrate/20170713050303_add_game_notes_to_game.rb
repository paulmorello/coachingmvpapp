class AddGameNotesToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :game_notes, :text
  end
end
