class AddGraduatingYearToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :graduating_year, :integer
  end
end
