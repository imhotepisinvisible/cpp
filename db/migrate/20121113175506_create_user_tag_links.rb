class CreateUserTagLinks < ActiveRecord::Migration
  def change
    create_table :user_tag_links do |t|
      t.references :user
      t.references :tag

      t.timestamps
    end
    add_index :user_tag_links, :user_id
    add_index :user_tag_links, :tag_id
  end
end
