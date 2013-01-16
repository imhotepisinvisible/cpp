# app/models/organisation_domain.rb
#
# A URL domain to validate emails of users signing up to departments.
# e.g. A student
#
# Schema Fields
#   t.integer  "organisation_id"
#   t.string   "domain"
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class OrganisationDomain < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :organisation

  ######################### Ensure present ##########################
  validates :domain, :presence => true

end
