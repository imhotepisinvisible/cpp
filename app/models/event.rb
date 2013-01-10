
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
#   t.datetime "created_at",     :null => false
#   t.datetime "updated_at",     :null => false

class Event < ActiveRecord::Base
  is_impressionable
  default_scope order('start_date ASC')

	belongs_to :company
  has_and_belongs_to_many :registered_students, :join_table => :student_event_registrations, :association_foreign_key => "user_id", :class_name => "Student"
  has_and_belongs_to_many :departments

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

  validates :departments, :presence => { :message => "Events must belong to at least one department" }

  attr_accessible :skill_list, :interest_list, :year_group_list,
                  :title, :start_date, :end_date, :deadline,
                  :description, :location, :capacity,
                  :company_id, :requirements

  attr_accessor :stat_count

  after_initialize :init

  def init
    self.stat_count ||= 0
  end

  # Returns a relevance score from 0 to 100 for student with the given id
  # TODO: Implement!
  def relevance(student_id)
    return 1
  end

  def to_audit_item(attribute = :created_at)
    if attribute == :created_at
      t = created_at
      message = "#{company.name}'s event '#{title}' was created"
    elsif attribute == :updated_at
      t = updated_at
      message = "#{company.name}'s event '#{title}' was updated"
    end
    AuditItem.new(self, t, 'event', message, "#events/#{id}")
  end

  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:relevance] = relevance(options[:student_id]) if options.has_key? :student_id
    result[:departments] = options[:depts] if options.has_key? :depts
    result[:stat_count] = @stat_count
    return result
  end
end
