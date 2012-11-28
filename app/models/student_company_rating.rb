class StudentCompanyRating < ActiveRecord::Base
  belongs_to :company
  belongs_to :student

  attr_accessible :company_id, :student_id, :rating
end