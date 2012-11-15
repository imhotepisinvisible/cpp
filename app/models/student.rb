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
  belongs_to :department

  acts_as_taggable_on :skills, :interests, :year_groups

  validates :department_id, :presence => true
  validates :bio, :length => { :maximum => 500 }
  validate :valid_email?

  attr_accessible :department_id, :year, :bio, :degree, :cv_location, :transcript_location, :covering_letter_location, :profile_picture_location

  def valid_email?
    if department.organisation.organisation_domains.any?
      match = false
      department.organisation.organisation_domains.each do |org_domain|
        unless /\A([^@\s]+)@#{org_domain.domain}/.match(email).nil?
          match = true
          break
        end
      end

      if !match
        domains = []
        department.organisation.organisation_domains.each do |org_domain|
          domains << org_domain.domain
        end
        errors.add(:email, "Email domain must be one of #{domains.join(", ")}")
      end
    end
  end

  def as_json(options={})
    super(:include => [:skills, :interests, :year_groups])
  end
end
