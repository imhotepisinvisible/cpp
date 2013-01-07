class CreateDepartmentRegistrations < ActiveRecord::Migration
  def change
    create_table :department_registrations do |t|
      t.references :company
      t.references :department
      t.integer    :status, :default => 0
      t.timestamps
    end
  end
end
