class CreatePracticeSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :practice_sessions do |t|
      t.text :practice_notes
      t.integer :user_id
      t.date :date
      t.text :practice_session_url
      t.text :focus
      t.text :additional_notes

      t.timestamps
    end
  end
end
