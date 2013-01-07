class CreateDepartmentsEvents < ActiveRecord::Migration
  def change
    create_table :departments_events do |t|
      t.references :department
      t.references :event
    end
  end
end
