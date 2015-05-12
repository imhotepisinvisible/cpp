class AddAvailableToUser < ActiveRecord::Migration
  def change
    add_column :users, :available, :string

  end
end
