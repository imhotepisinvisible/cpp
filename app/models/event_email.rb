# TaggedEmail class. for emails to all students matching a given set of tags.
class EventEmail < Email

	belongs_to :event

	attr_accessible :event_id

end
