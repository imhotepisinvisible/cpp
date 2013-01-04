class AddEventToEmail < ActiveRecord::Migration
  def change
  	change_table :emails do |t|
		  t.references :event
		end
  end
end
