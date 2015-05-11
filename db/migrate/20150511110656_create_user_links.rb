class CreateUserLinks < ActiveRecord::Migration
  def change
    create_table :user_links do |t|
      t.references :student
      t.string :gitHub
      t.string :linkedIn
      t.string :personal
      t.string :other
    end
    #execute "INSERT INTO user_links(student_id) SELECT users.id FROM users WHERE type = 'Student';"
  end
end
