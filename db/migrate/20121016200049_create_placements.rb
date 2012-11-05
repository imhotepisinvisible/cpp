class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.references :company
      t.string :position
      t.text :description
      t.string :duration
      t.string :location
      t.datetime :deadline

      t.string :open_to
      t.string :salary
      t.text :benefits
      t.text :application_procedure
      t.datetime :interview_date
      t.text :other

      t.timestamps
    end
  end
end
