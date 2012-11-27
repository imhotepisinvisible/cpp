class CreateDepartmentsStudents < ActiveRecord::Migration
  def change
    create_table :departments_students do |t|
      t.references :user
      t.references :department
    end
  end
end
