class AddRejectReasonToEmail < ActiveRecord::Migration
  def change
  	change_table :emails do |t|
		  t.string :reject_reason
		end
  end
end
