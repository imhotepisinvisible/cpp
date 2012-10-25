class CreateOrganisationDomains < ActiveRecord::Migration
  def change
    create_table :organisation_domains do |t|
      t.integer :organisation_id
      t.string :domain

      t.timestamps
    end
  end
end
