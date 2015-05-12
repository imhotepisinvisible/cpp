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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name
  ##################### On delete hide record ########################
  # acts_as_paranoid

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
