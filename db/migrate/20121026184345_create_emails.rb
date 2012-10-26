class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.string :body
      t.datetime :created
      t.datetime :sent # Presume sent will also imply approved.

      t.references :company
      # References to tags will go here.

      t.timestamps
    end
  end
end
