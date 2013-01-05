# app/models/user.rb
#
# A user is more 'abstract'. It contains password and email fields for auth
#
# Schema Fields
#   t.string   "email"
#   t.string   "password_digest"
#   t.integer  "department_id"
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class User < ActiveRecord::Base
  acts_as_paranoid
  # :column => 'deleted_at'

  has_secure_password

  validates :email,           :presence => true
  validates :password_digest, :presence => true, :on => :create
  validates :first_name,      :presence => true
  validates :last_name,       :presence => true

  validates :email, :uniqueness => true

  validates :password, :length => {
    :minimum => 8,
    :too_short => "password is too short, must be at least %{count} characters"
  }, :on => :create

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

  def is_student?
    self.class.name == "Student"
  end

  def is_company_admin?
    self.class.name == "CompanyAdministrator"
  end

  def is_department_admin?
    self.class.name == "DepartmentAdministrator"
  end

  def is_admin?
    is_company_admin? || is_department_admin?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
