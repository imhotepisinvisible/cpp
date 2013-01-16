# Schema Fields
#   t.string   "first_name"
#   t.string   "last_name"
#   t.string   "email"
#   t.string   "role"
#   t.integer  "position"
#   t.integer  "company_id"

class CompanyContact < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :company

  ################### Allow sorting and reordering ###################
  acts_as_list :scope => :company

  ######################### Ensure present ###########################
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :email,      :presence => true
  validates :role,       :presence => true

  ############ Attributes can be set via mass assignment ############
  attr_accessible :first_name, :last_name, :email, :role, :company_id, :position
end
