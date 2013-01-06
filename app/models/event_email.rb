# EventEmail class. for emails to all students attending a given event.
class EventEmail < Email

	belongs_to :event

	attr_accessible :event, :event_id

	def get_matching_students
		event.registered_students
	end


end
