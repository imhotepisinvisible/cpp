class CreateDepartmentsPlacements < ActiveRecord::Migration
  def change
    create_table :departments_placements do |t|
      t.references :department
      t.references :placement
    end
  end
end
