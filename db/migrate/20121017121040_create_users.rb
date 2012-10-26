class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :organisation_id

      t.integer :profile_id

      t.string :type

      t.timestamps
    end
  end
end
