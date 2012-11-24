class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.datetime :deleted_at

      # Student Fields
      t.references :department
      t.integer :year, :default => "?"
      t.text :bio, :default => ""
      t.text :degree, :default => ""
      t.boolean :active, :default => true

      # Company Admin Fields
      t.references :company # Company for Company Admin

      t.string :type

      t.timestamps
    end
  end
end
