class AddTitleToPracticeSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :practice_sessions, :title, :string
  end
end
