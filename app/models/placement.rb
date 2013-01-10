# app/models/placement.rb
#
# Companies can advertise placements to students in different departments
#
# Schema Fields
#   t.integer  "company_id"
#   t.string   "position"
#   t.text     "description"
#   t.string   "duration"
#   t.string   "location"
#   t.datetime "deadline"
#   t.datetime "created_at",  :null => false
#   t.datetime "updated_at",  :null => false

class Placement < ActiveRecord::Base
  is_impressionable
  default_scope order('created_at DESC')
  belongs_to :company

  acts_as_taggable_on :skills, :interests, :year_groups
  attr_accessible :skill_list, :interest_list, :year_group_list,
                  :company_id, :position, :location, :description,
                  :duration, :deadline, :salary, :benefits,
                  :application_procedure, :interview_date, :other

  validates :company_id,  :presence => true
  validates :position,    :presence => true
  validates :location,    :presence => true
  validates :description, :presence => true

  validates :description, obscenity: {message: "Profanity is not allowed!"}
  validates :position, obscenity: {message: "Profanity is not allowed!"}

  validates_datetime :deadline,
    :after => :now,
    :after_message => "Cannot be in the past",
    :allow_nil => :true

  validates_datetime :interview_date,
    :after => :now,
    :allow_nil => :true

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
      message = "'#{position}' created"
    elsif attribute == :updated_at
      t = updated_at
      message = "'#{position}' updated"
    end
    AuditItem.new(self, t, 'placement', message, "#placements/#{id}")
  end

  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:relevance] = relevance(options[:student_id]) if options.has_key? :student_id
    result[:stat_count] = @stat_count
    return result
  end
end
