# app/models/company.rb
#
# A company in the CPP system e.g. Google
#
# Schema Fields
#   t.string   "name"
#   t.text     "description"
#   t.integer  "organisation_id"
#   t.string   "logo_file_name"
#   t.string   "logo_content_type"
#   t.integer  "logo_file_size"
#   t.datetime "logo_updated_at"

# Describes attributes of Company and validations.
class Company < ActiveRecord::Base
  ####################### Log company actions ########################
  is_impressionable

  ###################### Declare associations ########################
  belongs_to :organisation

  has_many :events
  has_many :placements
  has_many :emails
  has_many :company_administrators, :dependent => :destroy
  has_many :company_contacts
  has_many :student_company_ratings
  has_many :department_registrations, :conditions => { :status => [2, 3] }

  has_many :departments, :through => :department_registrations
  has_many :accessible_students, :through => :departments,
           :class_name => "Student", :source => :students
  has_many :pending_department_registrations, :conditions => { :status => 1 },
           :class_name => "DepartmentRegistration"
  has_many :pending_departments, :through => :pending_department_registrations,
           :class_name => "Department", :source => :department

  has_many :all_department_registrations, :class_name => "DepartmentRegistration"
  has_many :all_departments, :through => :all_department_registrations,
           :class_name => "Department", :source => :department

  ######################### Declare tags ###########################
  acts_as_taggable_on :skills, :interests, :year_groups


  #################### Validate attached file ######################
  has_attached_file :logo,
    :styles => {
      :large => "1000x350",
      :medium => "500x175",
      :thumbnail => "100x35"
    },
    :default_url => '/assets/default_logo.png'

  validates_attachment :logo,
    :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/png"],
                        message: "Must be a jpeg or png file"}


  ######################### Ensure present #########################
  validates :name,            :presence => true
  validates :description,     :presence => true
  validates :organisation_id, :presence => true

  validates :pending_departments,
            :presence => { :message => "Must belong to at least one department" },
            :if => lambda { self.departments.empty? }
  validates :departments,
            :presence => { :message => "Must belong to at least one department" },
            :if => lambda { self.pending_departments.empty? }

  ######################### Ensure unique #########################
  validates :name, :uniqueness => true

  ######################## Ensure length #########################
  validates :description, :length => {
    :maximum => 2000,
  }

  ###################### Disallow Profanity ######################
  validates :name, obscenity: { message: "Profanity is not allowed!" }
  validates :description, obscenity: { message: "Profanity is not allowed!" }

  ###############################################################
  # Attributes not to store in database direectly and exist
  # for life of object
  # #############################################################
  attr_accessor :stat_count

  after_initialize :init

  # Set stat count to 0
  def init
    self.stat_count ||= 0
  end

  # Returns the rating for this company for the student for the given student_id
  # Ratings are on a scale from 1 to 3
  #   1 - Dislike/block
  #   2 - Neutral (default)
  #   3 - Like
  def rating(student_id)
    student_company_rating = student_company_ratings.find_by_student_id(student_id)
    if student_company_rating
      return student_company_rating.rating
    else
      return 2
    end
  end

  # Creates a new audit item for when the model was last created/updated
  def to_audit_item(attribute = :created_at)
    if attribute == :created_at
      t = created_at
      message = "#{name} signed up!"
    elsif attribute == :updated_at
      t = updated_at
      message = "#{name} updated their profile"
    end
    AuditItem.new(self, t, 'company', message, "#companies/#{id}")
  end

  # Converts company to JSON object
  # TODO: Bit more comment
  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:logo_url] = logo.url(:large)
    if options.has_key? :student_id
      result[:rating] = rating(options[:student_id])
    end

    result[:stat_count] = @stat_count

    return result
  end
end
