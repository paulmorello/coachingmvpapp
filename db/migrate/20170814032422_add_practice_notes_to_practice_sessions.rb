class AddPracticeNotesToPracticeSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :practice_sessions, :practice_notes, :string
  end
end
