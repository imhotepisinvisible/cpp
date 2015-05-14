class AddDetailsToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :link, :string
    add_column :placements, :contact, :string
  end
end
