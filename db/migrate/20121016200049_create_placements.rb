class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.integer :company_id
      t.string :position
      t.text :description
      t.string :duration
      t.string :location
      t.datetime :deadline

      t.timestamps
    end
  end
end
