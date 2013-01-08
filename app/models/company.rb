# app/models/company.rb
#
# A company in the CPP system e.g. Google
#
# Schema Fields
#   t.string   "name"
#   t.string   "logo"
#   t.text     "description"
#   t.integer  "organisation_id"
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class Company < ActiveRecord::Base
  is_impressionable

  belongs_to :organisation

	has_many :events
  has_many :placements
  has_many :emails
  has_many :company_administrators, :dependent => :destroy
  has_many :company_contacts
  has_many :student_company_ratings
  has_many :accessible_students, :through => :departments, :class_name => "Student", :source => :students

  has_many :department_registrations, :conditions => { :status => [2, 3] }
  has_many :departments        , :through => :department_registrations

  has_many :pending_department_registrations, :conditions => { :status => 1 }, :class_name => "DepartmentRegistration"
  has_many :pending_departments, :through => :pending_department_registrations, :class_name => "Department", :source => :department

  has_many :all_department_registrations, :class_name => "DepartmentRegistration"
  has_many :all_departments, :through => :all_department_registrations, :class_name => "Department", :source => :department

  acts_as_taggable_on :skills, :interests, :year_groups

  has_attached_file :logo,
    :styles => {
      :large => "1000x350",
      :medium => "500x175",
      :thumbnail => "100x35"
    },
    :default_url => '/assets/default_profile.png'

  validates_attachment :logo,
    :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/png"],
                        message: "Must be a jpeg or png file"}

  validates :pending_departments,     :presence => { :message => "Must belong to at least one department" }, :if => lambda { self.departments.empty? }
  validates :departments,             :presence => { :message => "Must belong to at least one department" }, :if => lambda { self.pending_departments.empty? }
  validates :name,                    :presence => true
  validates :description,             :presence => true
  validates :organisation_id,         :presence => true

  validates :name, obscenity: {message: "Profanity is not allowed!"}
  validates :description, obscenity: {message: "Profanity is not allowed!"}

  validates :name, :uniqueness => true

  validates :description, :length => {
    :maximum => 1000,
  }

  def rating(student_id)
    student_company_rating = student_company_ratings.find_by_student_id(student_id)
    if student_company_rating
      return student_company_rating.rating
    else
      return 2
    end
  end

  def as_json(options={})
    result = super(:methods => [:skill_list, :interest_list, :year_group_list])
    result[:logo_url] = logo.expiring_url(20, :large)
    if options.has_key? :student_id
      result[:rating] = rating(options[:student_id])
    end

    return result
  end
end
