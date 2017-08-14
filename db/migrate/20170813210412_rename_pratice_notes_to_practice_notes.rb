class RenamePraticeNotesToPracticeNotes < ActiveRecord::Migration[5.1]
  def change
    rename_column :practice_sessions, :pratice_notes, :practice_notes
  end
end
