class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :tag_category

      t.timestamps
    end
    add_index :tags, :tag_category_id
  end
end
