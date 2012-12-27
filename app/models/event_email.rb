# EventEmail class. for emails to all students attending a given event.
class EventEmail < Email

	belongs_to :event

	attr_accessible :event_id

	def send_email
		this.event.users.each do |user|
			queue_email(this, user)
		end
	end

end
