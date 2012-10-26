class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.integer :student_id
      t.integer :year
      t.text :bio
      t.text :degree

      t.timestamps
    end
  end
end
