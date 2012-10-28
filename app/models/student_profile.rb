class StudentProfile < ActiveRecord::Base
  belongs_to :student
  validates :student,  :presence => true

  # TODO: Can't test this using a factory as each point
  # to each other. How to fix?
  # validates :student_id, :presence => true
  validates :year,       :presence => true
  validates :bio,        :presence => true
  validates :degree,     :presence => true

  # TODO: How much do we want to limit it to? Also do we want to force them to
  # have a bio? Should we make :in be 0..500?
  validates :bio, :length => {
    :in => 1..500,
    :too_short => "must have at least %{count} characters",
    :too_long  => "must have at most %{count} characters"
  }

end
