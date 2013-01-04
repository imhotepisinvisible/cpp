class CreateDepartmentRegistrations < ActiveRecord::Migration
  def change
    create_table :department_registrations do |t|
      t.references :company
      t.references :department
      t.boolean    :approved, :default => false
      t.timestamps
    end
  end
end
