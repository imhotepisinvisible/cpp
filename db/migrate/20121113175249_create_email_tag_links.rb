class CreateEmailTagLinks < ActiveRecord::Migration
  def change
    create_table :email_tag_links do |t|
      t.references :email
      t.references :tag

      t.timestamps
    end
    add_index :email_tag_links, :email_id
    add_index :email_tag_links, :tag_id
  end
end
