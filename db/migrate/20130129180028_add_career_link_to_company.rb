class AddCareerLinkToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :career_link, :string
  end
end
