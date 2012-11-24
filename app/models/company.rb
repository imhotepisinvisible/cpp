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

  belongs_to :organisation
  has_and_belongs_to_many :departments

  acts_as_taggable_on :skills, :interests, :year_groups

  validates :name,            :presence => true
  validates :logo,            :presence => true
  validates :description,     :presence => true
  validates :organisation_id, :presence => true

  validates :name, obscenity: {message: "Profanity is not allowed!"}
  validates :description, obscenity: {message: "Profanity is not allowed!"}

  validates :description, :length => {
    :maximum => 1000,
  }

  def as_json(options={})
    super(:include => [:skills, :interests, :year_groups])
  end
end
