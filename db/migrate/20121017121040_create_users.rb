class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.string :type
      t.integer :student_profile_id

      t.timestamps
    end
  end
end
