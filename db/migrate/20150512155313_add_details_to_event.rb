class AddDetailsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :contact, :string

    add_column :events, :link, :string

  end
end
