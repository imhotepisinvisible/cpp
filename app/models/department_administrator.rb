class DepartmentAdministrator < User
  belongs_to :department

  attr_accessible :department_id
end
