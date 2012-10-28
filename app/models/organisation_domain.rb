class OrganisationDomain < ActiveRecord::Base
  belongs_to :organisation

  validates :organisation_id, :presence => true
  validates :domain,          :presence => true

end
