class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :company
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :deadline
      t.text :description
      t.string :location
      t.integer :capacity
      t.string :google_map_url

      t.timestamps
    end
  end
end
