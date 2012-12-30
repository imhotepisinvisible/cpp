class CompanyAdministrator < User
  belongs_to :company

  attr_accessible :company_id

  def as_json(options={})
    super(:methods => [:type])
  end
end
