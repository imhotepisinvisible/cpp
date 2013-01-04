class CreateDepartmentRegistrations < ActiveRecord::Migration
  def change
    create_table :department_registrations do |t|
      t.references :company
      t.references :department
      t.integer    :status, :default => 1 # 1-Pending, 2-Accepted, (-1)-Rejected
      t.timestamps
    end
  end
end
