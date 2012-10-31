class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      
      t.references :department # Department for Student
      t.references :company # Company for Company Admin

      t.string :type

      t.timestamps
    end
  end
end
