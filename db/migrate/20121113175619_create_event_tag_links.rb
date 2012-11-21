class CreateEventTagLinks < ActiveRecord::Migration
  def change
    create_table :event_tag_links do |t|
      t.references :event
      t.references :tag

      t.timestamps
    end
    add_index :event_tag_links, :event_id
    add_index :event_tag_links, :tag_id
  end
end
