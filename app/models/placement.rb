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
  ##################### Log placement actions ########################
  is_impressionable

  #################### Set default object scope#######################
  default_scope order('created_at DESC')

  ###################### Declare associations ########################
  belongs_to :company

  ######################### Declare tags #############################
  acts_as_taggable_on :skills, :interests, :year_groups

  ############ Attributes can be set via mass assignment ############
  attr_accessible :skill_list, :interest_list, :year_group_list,
                  :company_id, :position, :location, :description,
                  :duration, :deadline, :salary, :benefits,
                  :application_procedure, :interview_date, :other

  ######################## Ensure present #########################
  validates :company_id,  :presence => true
  validates :position,    :presence => true
  validates :location,    :presence => true
  validates :description, :presence => true

  ###################### Disallow Profanity #######################
  validates :description, obscenity: { message: "Profanity is not allowed!" }
  validates :position, obscenity: { message: "Profanity is not allowed!" }

  ####################### Validate date fields ######################
  validates_datetime :deadline,
    :after => :now,
    :after_message => "Cannot be in the past",
    :allow_nil => :true

  validates_datetime :interview_date,
    :after => :now,
    :allow_nil => :true

  ###################### Sanitize HTML ###############################
  sanitizes :description

  ##################################################################
  # Attributes not to store in database direectly and exist
  # for life of object
  # ################################################################
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

  # Creates a new audit item for when the model was last created/updated
  def to_audit_item(attribute = :created_at)
    if attribute == :created_at
      t = created_at
      message = "'#{position}' created"
    elsif attribute == :updated_at
      t = updated_at
      message = "'#{position}' updated"
    end
    AuditItem.new(self, t, 'placement', message, "placements/#{id}")
  end

  # Return JSON object
  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:relevance] = relevance(options[:student_id]) if options.has_key? :student_id
    result[:departments] = options[:depts] if options.has_key? :depts
    result[:stat_count] = @stat_count
    result[:company_name] = company.name
    result[:company_logo_url] = company.logo.url(:thumbnail)
    unless deadline.nil?
      result[:deadline] = deadline.to_datetime.iso8601
    end
    unless interview_date.nil?
      result[:interview_date] = interview_date.to_datetime.iso8601
    end
    return result
  end

  include Workflow
  workflow do
    state :new do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
    end
    state :rejected do
      event :edit, :transitions_to => :new
    end
    state :approved
  end
end
