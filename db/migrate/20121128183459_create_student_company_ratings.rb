class CreateStudentCompanyRatings < ActiveRecord::Migration
  def change
    create_table :student_company_ratings do |t|
      t.references :student
      t.references :company
      t.integer    :rating, :default => "1"
    end
  end
end
