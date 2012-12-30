class DepartmentAdministrator < User
  belongs_to :department

  attr_accessible :department_id

  def as_json(options={})
    super(:methods => [:type])
  end
end
