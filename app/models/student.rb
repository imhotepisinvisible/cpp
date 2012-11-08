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

  validates :department_id, :presence => true
  # validates :year,       :presence => true
  # validates :bio,        :presence => true
  # validates :degree,     :presence => true

  # TODO: How much do we want to limit it to? Also do we want to force them to
  # have a bio? Should we make :in be 0..500?
  validates :bio, :length => {
    :maximum => 500,
  }

  attr_accessible :department_id, :year, :bio, :degree, :cv_location
end
