# app/models/department.rb
#
# A department belongs to an organisation.
# The "Computing" department belongs to the "Imperial College" organization
#
# Schema Fields
#   t.string   "name"
#   t.integer  "organisation_id"
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class Department < ActiveRecord::Base
  belongs_to :organisation
  has_many :students
  #has_many :admins
  has_and_belongs_to_many :companies

  validates :name,            :presence => true
  validates :organisation_id, :presence => true
end
