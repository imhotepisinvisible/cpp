
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
  has_and_belongs_to_many :registered_students, :join_table => :student_event_registrations, :class_name => "Student", :table_name => :users

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

  attr_accessible :skill_list, :interest_list, :year_group_list,
                  :title, :start_date, :end_date, :deadline,
                  :description, :location, :capacity, :google_map_url,
                  :company_id

  # Returns a relevance score from 0 to 100 for student with the given id
  # TODO: Implement!
  def relevance(student_id)
    return 1
  end

  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:relevance] = relevance(options[:student_id]) if options.has_key? :student_id
    return result
  end
end
