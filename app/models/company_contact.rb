class CompanyContact < ActiveRecord::Base
  belongs_to :company

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email,      :presence => true
  validates :role,       :presence => true

  attr_accessible :first_name, :last_name, :email, :role, :company_id
end
