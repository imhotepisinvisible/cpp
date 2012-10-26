class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.references :department

      t.references :profile

      t.string :type

      t.timestamps
    end
  end
end
