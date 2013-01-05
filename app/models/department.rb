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
  has_and_belongs_to_many :students, :association_foreign_key => :user_id
  has_many :department_registrations, :conditions => { :status => 2 }
  has_many :pending_department_registrations, :conditions => { :status => 1 }, :class_name => "DepartmentRegistration"
  has_many :companies        , :through => :department_registrations
  has_many :pending_companies, :through => :pending_department_registrations, :class_name => "Company", :source => :company

  validates :name,            :presence => true
  validates :organisation_id, :presence => true


  # Includes the registration status
  # 0  - Not requested
  # 1  - Requested (pending)
  # 2  - Approved
  # -1 - Rejected
  def as_json(options={})
    result = super()
    if options.has_key? :company_id
      dept_reg = DepartmentRegistration.find_by_company_id_and_department_id(options[:company_id], id)
      puts dept_reg.inspect
      if dept_reg
        result[:status] = dept_reg.status
      else
        result[:status] = 0
      end
    end
    return result
  end
end
