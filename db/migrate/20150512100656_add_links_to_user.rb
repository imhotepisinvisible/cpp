class AddLinksToUser < ActiveRecord::Migration
  def change
    add_column :users, :gitHub, :string

    add_column :users, :linkedIn, :string

    add_column :users, :personal, :string

    add_column :users, :other, :string

  end
end
