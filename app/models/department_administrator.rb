# Schema Fields
#   t.string :first_name
#   t.string :last_name
#   t.string :email
#   t.string :password_digest
#   t.datetime :deleted_at
#   t.boolean :tooltip, :default => true
#   t.references :department

class DepartmentAdministrator < User
  ###################### Declare associations ########################
  belongs_to :department

  has_one  :organisation, :through => :department

  has_many :companies,
           :through => :department,
           :uniq => true,
           :source => :all_companies
  has_many :events,
           :through => :companies,
           :uniq => true
  has_many :placements,
           :through => :companies,
           :uniq => true

  ############ Attributes can be set via mass assignment ############
  attr_accessible :department_id

  # Returns JSON object 
  def as_json(options={})
    super(:methods => [:type])
  end
end
