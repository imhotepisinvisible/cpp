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
  has_many :students
  has_many :events
  has_many :placements

  ###################### Ensure present #######################
  validates :name,            :presence => true


  # Includes the registration status
  # -1 - Rejected
  # 0  - Not requested
  # 1  - Requested (pending)
  # 2  - Approved (visible to students)
  # 3  - Partner (Can see students)
  def as_json(options={})
    result = super()
    if options.has_key? :company_id
      dept_reg = Company.find_by_company_id(options[:company_id])
      if dept_reg
        result[:status] = dept_reg.reg_status
      else
        result[:status] = 0
      end
    end
    return result
  end
end
