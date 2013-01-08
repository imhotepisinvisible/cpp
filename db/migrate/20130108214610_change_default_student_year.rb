class ChangeDefaultStudentYear < ActiveRecord::Migration
  def change
    change_column :users, :year, :integer, :default => nil
  end
end
