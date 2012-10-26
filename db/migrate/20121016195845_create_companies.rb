class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo
      t.text :description
      t.references :organisation

      t.timestamps
    end
  end
end
