class AddDetailsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :size, :string

    add_column :companies, :sector, :string

    add_column :companies, :hq, :string

    add_column :companies, :founded, :int

  end
end
