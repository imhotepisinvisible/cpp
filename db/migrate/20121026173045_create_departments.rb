class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.references :organisation
      t.text :settings_notifier_placement # To be displayed when a company creates new placement
      t.text :settings_notifier_event     # To be displayed when a company creates new event

      t.timestamps
    end
  end
end
