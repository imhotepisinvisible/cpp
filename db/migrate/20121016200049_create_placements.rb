class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.references :company
      t.string :position
      t.text :description
      t.string :duration
      t.string :location
      t.datetime :deadline

      t.timestamps
    end
  end
end
