# app/models/email.rb
#
# Emails which are sent out by companies to students in various departments
# e.g. "ARM is Hiring!" could be sent out to "Computing" and "EEE" students if
#      ARM was signed up to both those departments
#
# Schema Fields
#   t.string   "subject"
#   t.string   "body"
#   t.datetime "created"
#   t.datetime "sent"
#   t.integer  "company_id"
#   t.datetime "created_at", :null => false
#   t.datetime "updated_at", :null => false
#
# Each email instantiation has a send_email function which queues the email
# with the users who will receive it.

class Email < ActiveRecord::Base
  belongs_to :company

  validates :company_id, :presence => true
  validates :subject,    :presence => true
  validates :body,       :presence => true
  validates :state,      :presence => true

  validates :body, obscenity: {message: "Profanity is not allowed!"}
  validates :subject, obscenity: {message: "Profanity is not allowed!"}

  validates_inclusion_of :state, :in => %w( Rejected Pending Approved Postponed )

  attr_accessible :company_id, :subject, :body, :state, :reject_reason

  def get_matching_students_count
    year_groups = Hash.new(0)
    get_matching_students.each do |user|
      year_groups[user.year] += 1
    end
    year_groups
  end

  def queue_email(email, user)
  	# Queueing logic would take place here if implemented.
  	UserMailer.send_email(user.email, email.subject, email.body).deliver
  end

  def send_email!
		get_matching_students.each do |user|
			Thread.new do
				queue_email(self, user)
			end
		end
	end

end
