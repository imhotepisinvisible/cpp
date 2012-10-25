class Organisation < ActiveRecord::Base
  has_many :companies
  has_many :organisation_domains

  validates :name, :presence => true
end
