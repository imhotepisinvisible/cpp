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
  has_and_belongs_to_many :students
  has_many :department_registrations, :conditions => { :approved => true }
  has_many :pending_department_registrations, :conditions => { :approved => false }, :class_name => "DepartmentRegistration"
  has_many :companies        , :through => :department_registrations
  has_many :pending_companies, :through => :pending_department_registrations, :class_name => "Company", :source => :company

  validates :name,            :presence => true
  validates :organisation_id, :presence => true
end
