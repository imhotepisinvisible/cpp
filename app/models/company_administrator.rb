class CompanyAdministrator < User
  belongs_to :company

  attr_accessible :company_id
end
