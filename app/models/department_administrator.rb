class DepartmentAdministrator < User
  belongs_to :department

  has_one  :organisation, :through => :department
  has_many :companies, :through => :department, :uniq => true
  has_many :events, :through => :companies, :uniq => true
  has_many :placements, :through => :companies, :uniq => true

  attr_accessible :department_id

  def as_json(options={})
    super(:methods => [:type])
  end
end
