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
  has_many :companies, :uniq => true
  has_many :events, :uniq => true
  has_many :placements, :uniq => true
  has_many :student_company_ratings

  has_one :course

  has_and_belongs_to_many :registered_events,
                          :join_table => :student_event_registrations,
                          :class_name => "Event",
                          :foreign_key => :user_id

  ########################## Declare tags ###########################
  acts_as_taggable_on :skills, :interests, :year_groups, :reject_skills, :reject_interests


  ######################### Validate fields #########################
  validates :bio, :length => { :maximum => 500 }

  ######################### Disallow Profanity #########################
  validates :bio, obscenity: { message: "Profanity is not allowed!" }
  validates :first_name, obscenity: { message: "Profanity is not allowed!" }
  validates :last_name, obscenity: { message: "Profanity is not allowed!" }

  ####################### Validate attached files ######################
  has_attached_file :cv, :styles => { :img => ["1240x1754", :png] }
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
                  :year_group_list, :active, :looking_for, :tooltip, :course_id, :cid

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
    !course_id.blank? &&
    !year.blank? &&
    !cv_file_size.nil?
  end

  # Creates a new audit item for when the model was last created/updated
  def to_audit_item
    AuditItem.new(self, created_at, 'student', "#{full_name} signed up!", "students/#{id}")
  end

  def send_admin_approval
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    opts = pending_reconfirmation? ? { to: unconfirmed_email } : { }
    send_devise_notification(:approval_instructions, @raw_confirmation_token, opts)
  end

  # Returns JSON object
  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list, :reject_skill_list, :reject_interest_list, :type])
    result[:stat_count] = @stat_count
    result[:confirmed] = confirmed_at?
    result[:cv_img] = cv.url(:img)
    if course_id?
      result[:course_name] = Course.find_by_id(course_id).name
    else
      result[:course_name] = "No course selected" 
    end 
    return result
  end

  def as_csv()
    attributes.except("password_digest")
  end

  def send_created
    UserMailer.account_created(self).deliver
  end

end
