class RemoveActivatedFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :activated, :boolean
  end
end
