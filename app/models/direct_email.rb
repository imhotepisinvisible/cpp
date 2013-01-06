# DirectEmail class. for emails to an individual or selected group of students.
class DirectEmail < Email

	has_one :student

	def get_matching_students
		student
	end
	
end
