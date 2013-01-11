# EventEmail class. for emails to all students attending a given event.
class EventEmail < Email
  ###################### Declare associations ########################
	belongs_to :event

  ############ Attributes can be set via mass assignment ############
	attr_accessible :event, :event_id

  # Returns students signed up to event
	def get_matching_students
		event.registered_students
	end


end
