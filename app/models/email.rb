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

  validates :body, obscenity: {message: "Profanity is not allowed!"}
  validates :subject, obscenity: {message: "Profanity is not allowed!"}

  attr_accessible :company_id, :subject, :body

end
