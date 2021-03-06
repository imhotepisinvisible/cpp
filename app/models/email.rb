# app/models/email.rb
#
# Emails which are sent out by companies to students in various departments
# e.g. "ARM is Hiring!" could be sent out to "Computing" and "EEE" students if
#      ARM was signed up to both those departments
#
# Each email instantiation has a send_email function which queues the email
# with the users who will receive it.
#
# Schema Fields
#   t.string   "subject"
#   t.string   "body"
#   t.datetime "created"
#   t.datetime "sent"
#   t.integer  "company_id"
#   t.string   "state"
#   t.datetime "created_at",    :null => false
#   t.datetime "updated_at",    :null => false
#   t.integer  "event_id"
#   t.string   "type"
#   t.string   "reject_reason"
#

class Email < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :company

  validates :company_id, :presence => true
  validates :subject,    :presence => true
  validates :body,       :presence => true
  validates :state,      :presence => true


  ####################### Disallow Profanity ########################
  validates :body, obscenity: { message: "Profanity is not allowed!" }
  validates :subject, obscenity: { message: "Profanity is not allowed!" }

  #################### Validates inclusion ##########################
  validates_inclusion_of :state, :in => %w( Rejected Pending Approved Postponed )


  ############## Attributes can be set via mass assignment ############
  attr_accessible :company_id, :subject, :body, :state, :reject_reason

  # Sorts the students fetched from call to get_matching_students by year
  # and returns a hash of year groups and their respective counts of students
  def get_matching_students_count
    year_groups = Hash.new(0)
    get_matching_students.each do |user|
      year_groups[user.year] += 1
    end
    year_groups
  end

  # Queues the sending of given 'email' for given 'user'
  # TODO: Implement queuing logic
  def queue_email(email, user)
  	if UserMailer.send_email(user.email, email.subject, email.body).deliver
      email.sent = true
      email.save!
    end
  end

  # Sends email to students that match the catagory
  def send_email!
    puts get_matching_students.inspect
		get_matching_students.each do |user|
      puts "creating thread to email: " + user.email
        # puts "thread created for email:" + user.email
			queue_email(self, user)
		end
	end

  def as_json(options={})
    result = super()
    unless company.nil?
      result[:company_name] = company.name
      result[:company_logo_url] = company.logo.url(:thumbnail)
    end
    return result
  end

end
