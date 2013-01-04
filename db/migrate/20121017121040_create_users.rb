class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.datetime :deleted_at
      t.boolean :tooltip, :default => true

      # Student Fields
      t.integer :year, :default => "?"
      t.text :bio, :default => ""
      t.text :degree, :default => ""
      t.boolean :active, :default => true
      t.string :looking_for, :default => "Not looking for anything"

      # Company Admin Fields
      t.references :company

      # Department Admin Fields
      t.references :department

      t.string :type

      t.timestamps
    end
  end
end
