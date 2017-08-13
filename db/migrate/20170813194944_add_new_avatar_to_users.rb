class AddNewAvatarToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :new_avatar, :string
  end
end
