# Schema:
#   t.integer  "company_id"
#   t.integer  "department_id"
#   t.integer  "status",        :default => 0
#   t.datetime "created_at",                   :null => false
#   t.datetime "updated_at",                   :null => false

class DepartmentRegistration < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :company
  belongs_to :department
end
