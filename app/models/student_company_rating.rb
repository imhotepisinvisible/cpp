class StudentCompanyRating < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :company
  belongs_to :student

  ####################################################################
  # Attributes not to store in database direectly and exist
  # for life of object
  # ##################################################################
  attr_accessible :company_id, :student_id, :rating
end