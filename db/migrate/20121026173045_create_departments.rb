class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :organisation_id

      t.timestamps
    end
  end
end
