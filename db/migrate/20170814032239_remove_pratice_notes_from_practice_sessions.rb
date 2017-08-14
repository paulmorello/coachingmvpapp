class RemovePraticeNotesFromPracticeSessions < ActiveRecord::Migration[5.1]
  def change
    remove_column :practice_sessions, :pratice_notes, :text
  end
end
