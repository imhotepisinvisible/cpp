class AddDefaultValueToLookingForAttribute < ActiveRecord::Migration
  def up
      change_column :users, :looking_for, :string, :default => "Not looking for anything"
  end

  def down
      change_column :users, :looking_for, :string, :default => nil
  end
end
