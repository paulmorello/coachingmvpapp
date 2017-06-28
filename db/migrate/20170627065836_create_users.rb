class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :email
      t.text :first_name
      t.text :last_name
      t.text :password_digest
      t.text :avatar
      t.text :username
      t.integer :game_id
      t.boolean :admin
      t.text :subscription
      t.integer :practice_session_id

      t.timestamps
    end
  end
end
