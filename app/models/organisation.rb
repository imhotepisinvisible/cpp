class Organisation < ActiveRecord::Base
  has_many :companies
  has_many :organisation_domains
  has_many :departments

  validates :name, :presence => true
end
