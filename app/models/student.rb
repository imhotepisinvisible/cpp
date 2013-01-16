# app/models/student.rb
#
# A student inherits from the user model and due to STI is stored in the 'users'
# table.
#
# Schema Fields
#   t.string   "email"
#   t.string   "password_digest"
#   t.integer  "department_id"
#   t.integer  "profile_id" # Link to student profile
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class Student < User
  ##################### Log placement actions ########################
  is_impressionable

  ##################### On delete hide record ########################
  acts_as_paranoid

  ###################### Declare associations ########################
  has_and_belongs_to_many :departments, :foreign_key => :user_id

  has_many :companies,  :through => :departments, :uniq => true
  has_many :events,     :through => :departments, :uniq => true
  has_many :placements, :through => :companies, :uniq => true
  has_many :student_company_ratings

  has_and_belongs_to_many :registered_events,
                          :join_table => :student_event_registrations,
                          :class_name => "Event",
                          :foreign_key => :user_id

  ########################## Declare tags ###########################
  acts_as_taggable_on :skills, :interests, :year_groups, :reject_skills, :reject_interests


  ######################### Validate fields #########################
  validates :departments, :presence => { :message => "Must belong to at least one department" }
  validates :bio, :length => { :maximum => 500 }
  validate :valid_email?


  ######################### Disallow Profanity #########################
  validates :bio, obscenity: { message: "Profanity is not allowed!" }
  validates :first_name, obscenity: { message: "Profanity is not allowed!" }
  validates :last_name, obscenity: { message: "Profanity is not allowed!" }

  ####################### Validate attached files ######################
  has_attached_file :cv
  has_attached_file :transcript
  has_attached_file :covering_letter
  has_attached_file :profile_picture,
                    :default_url => '/assets/default_profile.png'

  validates_attachment :cv, :transcript, :covering_letter,
      :content_type => { :content_type => ["application/pdf", "text/plain"],
                         message: "Must be a pdf or text file" }

  validates_attachment :profile_picture,
      :content_type => { :content_type => ["image/jpeg", "image/png"],
                          message: "Must be a jpeg or png file"}

  ############## Attributes can be set via mass assignment ############
  attr_accessible :year, :bio, :degree, :email, :cv, :transcript,
                  :covering_letter, :profile_picture, :skill_list,
                  :interest_list, :reject_skill_list, :reject_interest_list,
                  :year_group_list, :active, :looking_for, :tooltip

  ####################################################################
  # Attributes not to store in database direectly and exist
  # for life of object
  # ##################################################################
  attr_accessor :stat_count

  after_initialize :init

  def init
    self.stat_count ||= 0
  end

  # Only active to companies if fields set
  def is_active?
    active &&
    !first_name.blank? &&
    !last_name.blank? &&
    !degree.blank? &&
    !year.blank? &&
    !cv_file_size.nil?
  end

  # Ensures email domain matches one of organisation specified emails
  def valid_email?
    if departments.blank? # Can't have org if no departments
      errors.add(:email, "Cannot validate email without department")
      return false
    end

    organisation = departments.first.organisation
    if organisation.organisation_domains.any?
      match = false
      organisation.organisation_domains.each do |org_domain|
        unless /\A([^@\s]+)@#{org_domain.domain}/.match(email).nil?
          match = true
          break
        end
      end

      if !match
        domains = []
        organisation.organisation_domains.each do |org_domain|
          domains << org_domain.domain
        end
        errors.add(:email, "Email domain must be one of #{domains.join(", ")}")
      end
    end
  end

  # Creates a new audit item for when the model was last created/updated
  def to_audit_item
    AuditItem.new(self, created_at, 'student', "#{full_name} signed up!", "#students/#{id}")
  end

  # Returns JSON object
  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list, :reject_skill_list, :reject_interest_list, :type])
    result[:stat_count] = @stat_count
    return result
  end

end
