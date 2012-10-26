class CreateOrganisationDomains < ActiveRecord::Migration
  def change
    create_table :organisation_domains do |t|
      t.references :organisation
      t.string :domain

      t.timestamps
    end
  end
end
