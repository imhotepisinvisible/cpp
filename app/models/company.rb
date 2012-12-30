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
	has_many :events
  has_many :placements
  has_many :emails
  has_many :company_administrators
  has_many :company_contacts
  has_many :student_company_ratings

  belongs_to :organisation
  has_and_belongs_to_many :departments

  acts_as_taggable_on :skills, :interests, :year_groups

  has_attached_file :logo,
    :path => ':rails_root/documents/logos/:id/:basename.:extension',
    :url => '/:class/:id/logo'

  validates_attachment :logo,
    :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/png"],
                        message: "Must be a jpeg or png file"}

  validates :departments,     :presence => { :message => "Must belong to at least one department" }
  validates :name,            :presence => true
  validates :description,     :presence => true
  validates :organisation_id, :presence => true

  validates :name, obscenity: {message: "Profanity is not allowed!"}
  validates :description, obscenity: {message: "Profanity is not allowed!"}

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

    if options.has_key? :student_id
      result[:rating] = rating(options[:student_id])
    end

    return result
  end
end
