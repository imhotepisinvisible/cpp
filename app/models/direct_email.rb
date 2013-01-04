# DirectEmail class. for emails to an individual or selected group of students.
class DirectEmail < Email

	has_and_belongs_to_many :students

	def get_matching_students
		this.students
	end
	
end
