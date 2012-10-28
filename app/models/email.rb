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

class Email < ActiveRecord::Base
  has_one :company

  validates :company_id, :presence => true
end
