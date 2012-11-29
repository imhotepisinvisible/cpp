# DirectEmail class. for emails to an individual or selected group of students.
class DirectEmail < Email

	has_and_belongs_to_many :students

	def send_email
		this.students.each do |student|
			queue_email(this,student)
		end
	end
	
end
