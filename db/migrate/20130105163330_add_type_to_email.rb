class AddTypeToEmail < ActiveRecord::Migration
  def change
  	change_table :emails do |t|
		  t.string :type
		end
  end
end
