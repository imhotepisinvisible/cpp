# Schema Fields
#   t.string :first_name
#   t.string :last_name
#   t.string :email
#   t.string :password_digest
#   t.datetime :deleted_at
#   t.boolean :tooltip, :default => true
#   t.references :company

class CompanyAdministrator < User
  ###################### Declare associations ########################
  belongs_to :company

  has_many :events,      :through => :company, :uniq => true
  has_many :placements,  :through => :company, :uniq => true

  ############ Attributes can be set via mass assignment ############
  attr_accessible :company_id

  # Returns JSON object
  def as_json(options={})
    super(:methods => [:type])
  end
end
