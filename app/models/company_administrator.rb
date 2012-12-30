class CompanyAdministrator < User
  belongs_to :company

  has_many :events, :through => :company, :uniq => true
  has_many :placements, :through => :company, :uniq => true
  has_many :departments, :through => :company, :uniq => true

  attr_accessible :company_id

  def as_json(options={})
    super(:methods => [:type])
  end
end
