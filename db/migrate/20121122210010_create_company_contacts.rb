class CreateCompanyContacts < ActiveRecord::Migration
  def change
    create_table :company_contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :role
      t.integer :position
      
      t.references :company

      t.timestamps
    end
  end
end
