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
  acts_as_paranoid

  has_and_belongs_to_many :departments, :foreign_key => :user_id
  has_many :companies, :through => :departments, :uniq => true
  has_many :events, :through => :companies, :uniq => true
  has_many :placements, :through => :companies, :uniq => true
  has_many :student_company_ratings
  has_and_belongs_to_many :registered_events, :join_table => :student_event_registrations, :class_name => "Event", :foreign_key => :user_id


  acts_as_taggable_on :skills, :interests, :year_groups, :reject_skills, :reject_interests

  validates :departments, :presence => { :message => "Must belong to at least one department" }
  validates :bio, :length => { :maximum => 500 }
  validate :valid_email?

  validates :bio, obscenity: {message: "Profanity is not allowed!"}
  validates :first_name, obscenity: {message: "Profanity is not allowed!"}
  validates :last_name, obscenity: {message: "Profanity is not allowed!"}

  has_attached_file :cv,
    :path => ':rails_root/documents/cvs/:id/:basename.:extension',
    :url => '/:class/:id/cv'

  validates_attachment :cv, :transcript, :covering_letter,
      :content_type => { :content_type => ["application/pdf", "text/plain"],
                         message: "Must be a pdf or text file" }

  validates_attachment :profile_picture,
      :content_type => { :content_type => ["image/jpeg", "image/png"],
                          message: "Must be a jpeg or png file"}

  has_attached_file :transcript,
    :path => ':rails_root/documents/transcripts/:id/:basename.:extension',
    :url => '/:class/:id/transcript'

  has_attached_file :covering_letter,
    :path => ':rails_root/documents/covering_letters/:id/:basename.:extension',
    :url => '/:class/:id/covering_letter'

  has_attached_file :profile_picture,
    :path => ':rails_root/documents/profile_pictures/:id/:basename.:extension',
    :url => '/:class/:id/profile_picture'

  attr_accessible :year, :bio, :degree, :email,
                    :cv, :transcript, :covering_letter, :profile_picture,
                    :skill_list, :interest_list, :reject_skill_list, :reject_interest_list, :year_group_list, :active,
                    :looking_for, :tooltip
  def is_active?
    #TODO: Add all conditions here!! e.g. missing fields
    active
  end

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

  def as_json(options={})
    super(:methods => [:skill_list, :interest_list, :year_group_list, :reject_skill_list, :reject_interest_list, :type])
  end

end
