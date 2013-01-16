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
#   t.text     "settings_notifier_placement"
#   t.text     "settings_notifier_event"

class Department < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :organisation

  has_and_belongs_to_many :students, :association_foreign_key => :user_id
  has_and_belongs_to_many :events

  has_many :department_registrations,
           :conditions => { :status => [2,3] }
  has_many :pending_department_registrations,
           :conditions => { :status => 1 },
           :class_name => "DepartmentRegistration"
  has_many :all_department_registrations,
           :class_name => "DepartmentRegistration"
  has_many :companies,
           :through => :department_registrations
  has_many :all_companies,
           :through => :all_department_registrations,
           :class_name => "Company",
           :source => :company
  has_many :pending_companies,
           :through => :pending_department_registrations,
           :class_name => "Company",
           :source => :company

  ###################### Ensure present #######################
  validates :name,            :presence => true
  validates :organisation_id, :presence => true


  # Includes the registration status
  # -1 - Rejected
  # 0  - Not requested
  # 1  - Requested (pending)
  # 2  - Approved (visible to students)
  # 3  - Partner (Can see students)
  def as_json(options={})
    result = super()
    if options.has_key? :company_id
      dept_reg = DepartmentRegistration.find_by_company_id_and_department_id(options[:company_id], id)
      if dept_reg
        result[:status] = dept_reg.status
      else
        result[:status] = 0
      end
    end
    return result
  end
end
