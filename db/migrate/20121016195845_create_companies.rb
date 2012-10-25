class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo
      t.text :description
      t.integer :organisation_id

      t.timestamps
    end
  end
end
