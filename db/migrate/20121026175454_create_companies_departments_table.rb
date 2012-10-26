class CreateCompaniesDepartmentsTable < ActiveRecord::Migration
  def change
    create_table :companies_departments, :id => false do |t|
      t.references :company
      t.references :department
    end
  end
end
