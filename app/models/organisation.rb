# app/models/organisation.rb
#
# An organisation is the highest level entity in the application.
# e.g. "Imperial College London"
#
# Schema Fields
#   t.string   "name"
#   t.datetime "created_at", :null => false
#   t.datetime "updated_at", :null => false
class Organisation < ActiveRecord::Base
  ###################### Declare associations ########################
  has_many :companies
  has_many :organisation_domains
  has_many :departments

  ######################### Ensure present ##########################
  validates :name, :presence => true
end
