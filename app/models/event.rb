# app/models/event.rb
#
# Events belong to a company
# e.g. "Deutsche Bank Pizza Evening"
#
# Schema Fields
#   t.integer  "company_id"
#   t.string   "title"
#   t.datetime "start_date"
#   t.datetime "end_date"
#   t.datetime "deadline"
#   t.text     "description"
#   t.string   "location"
#   t.integer  "capacity"
#   t.string   "google_map_url"
#   t.datetime "created_at",     :null => false
#   t.datetime "updated_at",     :null => false

class Event < ActiveRecord::Base
	belongs_to :company

  acts_as_taggable_on :skills, :interests, :year_groups

	validates :company_id,   :presence => true
	validates :title,        :presence => true
	validates :description,  :presence => true
	validates :location,     :presence => true
  validates :start_date,   :presence => true
  validates :end_date,     :presence => true

  validates :description, obscenity: {message: "Profanity is not allowed!"}
  validates :title, obscenity: {message: "Profanity is not allowed!"}

  validates_datetime :start_date,
    :after => :now,
    :after_message => "Event cannot start in the past"

  validates_datetime :end_date,
    :after => :start_date,
    :after_message => "End time cannot be before start time"

  def as_json(options={})
    super(:include => [:skills, :interests, :year_groups])
  end
end
