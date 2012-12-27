class CreateStudentEventRegistrations < ActiveRecord::Migration
  def change
    create_table :student_event_registrations do |t|
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :student_event_registrations, :user_id
    add_index :student_event_registrations, :event_id
  end
end
