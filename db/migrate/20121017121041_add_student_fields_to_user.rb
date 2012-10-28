class AddStudentFieldsToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.references :profile
    end
  end
 
  def down
    remove_column :users, :profile_id
  end
end


