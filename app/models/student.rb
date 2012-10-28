# app/models/student.rb
#
# A student inherits from the user model and due to STI is stored in the 'users'
# table.
#
# Schema Fields
#   t.string   "email"
#   t.string   "password_digest"
#   t.integer  "department_id"
#   t.integer  "profile_id" # Link to student profile
#   t.datetime "created_at",      :null => false
#   t.datetime "updated_at",      :null => false

class Student < User
  belongs_to :department

  has_one :profile,
          :class_name => "StudentProfile",
          :foreign_key => "student_id",
          :autosave => true,
          :dependent => :destroy,
          :inverse_of => :student

  default_scope :include => :profile

  delegate :year, :year=, :bio, :bio=, :degree, :degree=, :to => :profile

  validates :department_id, :presence => true
end
