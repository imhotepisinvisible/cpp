# DirectEmail class, used for emails to an individual or selected group of
# students.

class DirectEmail < Email
  ###################### Declare associations ########################
	has_one :student

  # Direct email returns student it is related to
	def get_matching_students
		student
	end
	
end
