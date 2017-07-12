class AddNeedsReviewToPracticeSessions < ActiveRecord::Migration[5.1]
  def change
    add_column :practice_sessions, :needs_review, :boolean
  end
end
