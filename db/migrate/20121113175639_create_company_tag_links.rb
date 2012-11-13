class CreateCompanyTagLinks < ActiveRecord::Migration
  def change
    create_table :company_tag_links do |t|
      t.references :company
      t.references :tag

      t.timestamps
    end
    add_index :company_tag_links, :company_id
    add_index :company_tag_links, :tag_id
  end
end
