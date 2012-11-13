class CreatePlacementTagLinks < ActiveRecord::Migration
  def change
    create_table :placement_tag_links do |t|
      t.references :placement
      t.references :tag

      t.timestamps
    end
    add_index :placement_tag_links, :placement_id
    add_index :placement_tag_links, :tag_id
  end
end
