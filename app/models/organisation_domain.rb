class OrganisationDomain < ActiveRecord::Base
  belongs_to :organisation

  validates :organisation, :presence => true
  validates :domain,       :presence => true

end
