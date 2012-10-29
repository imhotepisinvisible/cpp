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
  belongs_to :organisation
  has_and_belongs_to_many :departments

  validates :name,            :presence => true
  validates :logo,            :presence => true
  validates :description,     :presence => true
  validates :organisation_id, :presence => true
  validates :description, :length => {
    :maximum => 500
  }
end
