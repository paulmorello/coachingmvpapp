class CreateDrills < ActiveRecord::Migration[5.1]
  def change
    create_table :drills do |t|
      t.text :drill_url
      t.text :title
      t.text :category
      t.text :description

      t.timestamps
    end
  end
end
