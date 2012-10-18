class Student < User
  default_scope includes(:student_profile)

  has_one :student_profile, :autosave => true

  delegate :year, :year=, :bio, :bio=, :degree, :degree=, :to => :student_profile
end
