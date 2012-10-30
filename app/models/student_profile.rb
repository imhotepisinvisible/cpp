# app/models/student_profile.rb
#
# Students all have a profile which stores additional information about them.
#
# Schema Fields
#   t.integer  "student_id"
#   t.integer  "year"
#   t.text     "bio"
#   t.text     "degree"
#   t.datetime "created_at", :null => false
#   t.datetime "updated_at", :null => false

class StudentProfile < ActiveRecord::Base
  belongs_to :student

  validates :student_id,  :presence => true
  validates :year,       :presence => true
  validates :bio,        :presence => true
  validates :degree,     :presence => true

  # TODO: How much do we want to limit it to? Also do we want to force them to
  # have a bio? Should we make :in be 0..500?
  validates :bio, :length => {
    :maximum => 500,
  }

end
