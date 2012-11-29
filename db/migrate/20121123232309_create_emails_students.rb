class CreateEmailsStudents < ActiveRecord::Migration
  def change
  	create_table :emails_students do |t|
	  	t.references :email
	  	t.references :user
	  end
  end
end
